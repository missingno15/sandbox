defmodule Websockets do
  require Logger

  # @wss_url "wss://online.showroom-live.com:443"
  @room_status_api_endpoint "https://www.showroom-live.com/api/room/status"

  def start(room_url_key) do
    socket = Socket.Web.connect!("online.showroom-live.com", secure: true)
    socket |> Socket.Web.send!( {:text, "SUB\t#{fetch_bcsvr_key(room_url_key)}"})
    socket |> Socket.Web.send!({:text, "PING\tshowroom"})

    Logger.info("Application started")

    loop(socket, %{}, DateTime.utc_now(), 0, 0)
  end

  defp loop(socket, _message, _start_interval, seconds_elapsed, comment_count) when seconds_elapsed >= 60 do
    Socket.Web.send!(socket, {:text, "PING\tshowroom"})

    Logger.info("#{comment_count} comments in the past minute")

    loop(socket, fetch_message(socket), DateTime.utc_now(), 0, 0)
  end

  defp loop(socket, message, start_interval, _seconds_elapsed, comment_count) when map_size(message) == 0 do
    loop(
      socket,
      fetch_message(socket),
      start_interval,
      DateTime.diff(DateTime.utc_now(), start_interval),
      comment_count
    )
  end

  defp loop(socket, %{"cm" => _} = message, start_interval, _seconds_elapsed, comment_count) do
    new_message = fetch_message(socket)

    loop(
      socket,
      message,
      start_interval,
      DateTime.diff(DateTime.utc_now(), start_interval),
      increment_comment_count(new_message, comment_count)
    )
  end

  defp loop(socket, _message, start_interval, _seconds_elapsed, comment_count) do
    loop(
      socket,
      fetch_message(socket),
      start_interval,
      DateTime.diff(DateTime.utc_now(), start_interval),
      comment_count
    )
  end

  defp fetch_message(socket)  do
    {:text, frame} = Socket.Web.recv!(socket)

    if not String.match?(frame, ~r/^MSG/) do
      %{}
    else
      frame
      |> String.split(~r/[[:space:]]/i, parts: 3)
      |> List.last()
      |> String.trim_leading("\"")
      |> String.trim_trailing("\"")
      |> Poison.decode!()
    end
  end

  defp increment_comment_count(%{"cm" => _cm}, comment_count), do: comment_count + 1
  defp increment_comment_count(_, comment_count), do: comment_count

  defp fetch_bcsvr_key(room_url_key) do
    case HTTPoison.get("#{@room_status_api_endpoint}?room_url_key=#{room_url_key}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode!(body) do
         %{"broadcast_key" => broadcast_key} ->
           broadcast_key
         _nothing ->
           nil
        end
      {:error, _error} ->
        fetch_bcsvr_key(room_url_key)
    end
  end
end

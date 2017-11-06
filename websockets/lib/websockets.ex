defmodule Websockets do
  require Logger

  # @wss_url "wss://online.showroom-live.com:443"
  @room_status_api_endpoint "https://www.showroom-live.com/api/room/status"

  def start(room_url_key) do
    socket = Socket.Web.connect!("online.showroom-live.com", secure: true)     
    socket |> Socket.Web.send!( {:text, "SUB\t#{fetch_bcsvr_key(room_url_key)}"})
    socket |> Socket.Web.send!({:text, "PING\tshowroom"})

    Logger.info("Application started")

    loop(socket, %{}, 0, 0)
  end

  defp loop(socket, message, seconds_elapsed, comment_count) when map_size(message) == 0 do
    loop(socket, fetch_message(socket), seconds_elapsed, comment_count) 
  end

  defp loop(socket, %{"cm" => _, "created_at" => created_at} = message, _seconds_elapsed, comment_count) do
    new_message = fetch_message(socket)

    loop(
      socket,
      message,
      DateTime.diff(DateTime.utc_now(), DateTime.from_unix!(created_at)),
      increment_comment_count(new_message, comment_count)
    )
  end
   
  defp loop(socket, _message, seconds_elapsed, comment_count) do
    loop(socket, fetch_message(socket), seconds_elapsed, comment_count) 
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

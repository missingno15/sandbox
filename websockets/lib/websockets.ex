require IEx
defmodule Websockets do
  require Logger

  # @wss_url "wss://online.showroom-live.com:443"
  @room_status_api_endpoint "https://www.showroom-live.com/api/room/status"

  def start(room_url_key) do
    socket = Socket.Web.connect!("online.showroom-live.com", secure: true)     
    socket |> Socket.Web.send!( {:text, "SUB\t#{fetch_bcsvr_key(room_url_key)}"})
    socket |> Socket.Web.send!({:text, "PING\tshowroom"})

    loop(socket, Timex.now, 0, 0)
  end

  defp loop(socket, _ping_time, time_elapsed_since_last_ping, comment_count) when time_elapsed_since_last_ping >= 60 do
    socket |> Socket.Web.send!({:text, "PING\tshowroom"})

    {:text, message} = socket |> Socket.Web.recv!()
    message 
    |> process_message()
    |> IO.inspect()

    Logger.info("#{comment_count} per minute")

    loop(socket, Timex.now, 0, 0) 
  end
  defp loop(socket, ping_time, _time_elapsed_since_last_ping, comment_count) do
    {:text, message} = socket |> Socket.Web.recv!()


    message 
    |> process_message()
    |> IO.inspect()

    new_comment_count = message 
                        |> process_message()
                        |> increment_comment_count(comment_count)

    # loop(socket, ping_time, Timex.diff(Timex.now, ping_time, :seconds), 0)
    loop(socket, ping_time, Timex.diff(Timex.now, ping_time, :seconds), new_comment_count)
  end

  defp process_message(message)  do
    if String.match?(message, ~r/^ACK/) do
      %{} 
    else
      message
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

defmodule Websockets do
  use WebSockex
  require Logger

  @wss_url "wss://online.showroom-live.com:443"
  @room_status_api_endpoint "https://www.showroom-live.com/api/room/status"

  @impl true
  def start_link(room_url_key) do
    state = %{
      # "comment_count" => 0,
      "broadcast_key" => fetch_bcsvr_key(room_url_key)
    }

    WebSockex.start_link(@wss_url, __MODULE__, state)
  end

  @impl true
  def handle_connect(_conn, state) do
    ping_heartbeat()

    # Connect to channel chat
    WebSockex.send_frame(self(), "SUB\t#{state["broadcast_key"]}")
    {:ok, state}
  end

  @impl true
  def handle_frame("MSG " <> data, state) when  do
    json = data
           |> String.trim_leader("#{state["broadcast_key"]} ")
           |> Poison.decode!()

    Logger.info(IO.inspect(json))

    {:ok, state}
  end

  @doc """
  Send a frame to the server to keep the connection alive
  """
  defp ping_heartbeat() do
    WebSockex.send_frame(self(), "PING\tshowroom")
    Process.send_after(self(), :ping_heartbeat, :timer.minutes(1))
  end

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

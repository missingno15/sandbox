require IEx
defmodule Websockets do
  require Logger

  @wss_url "wss://online.showroom-live.com:443"
  @room_status_api_endpoint "https://www.showroom-live.com/api/room/status"

  def play(room_url_key) do
    wss_url = "wss://online.showroom-live.com:443"
    broadcast_key = fetch_bcsvr_key(room_url_key)
    IEx.pry() 
  end

  # def start_link(room_url_key) do
  #   broadcast_key = fetch_bcsvr_key(room_url_key)
  #   IO.puts room_url_key
  #   IO.puts broadcast_key

  #   state = %{
  #     # "comment_count" => 0,
  #     "broadcast_key" => broadcast_key
  #   }

  #   IO.inspect state

  #   conn = 
  #     URI.parse(@wss_url)
  #     |> WebSockex.Conn.new(extra_headers: [{"Cookie", "_ga=GA1.2.2007546761.1507291116; _gid=GA1.2.792637120.1507291116"}], socket_connect_timeout: :timer.seconds(10), insecure: false, cacerts: ["/home/kenneth/Projects/sandbox/websockets/cacert-root.crt", "/home/kenneth/Projects/sandbox/websockets/cacert-class3.crt"])

  #   WebSockex.start_link(conn, __MODULE__, state, debug: [:trace, :log])
  # end

  # @impl true
  # def handle_connect(_conn, state) do
  #   Logger.info("Broadcast key: #{state["broadcast_key"]}")
  #   # Connect to channel chat
  #   WebSockex.send_frame(self(), {:text, "SUB\t#{state["broadcast_key"]}" })

  #   # Send a frame to the server to keep the connection alive
  #   ping_heartbeat()

  #   Logger.info("Connected!")
  #   {:ok, state}
  # end

  # @impl true
  # def handle_frame({:text, "MSG\t" <> data}, state) do
  #   json = data
  #          |> String.trim_leading("#{state["broadcast_key"]} ")
  #          |> Poison.decode!()

  #   Logger.info(json)

  #   {:ok, state}
  # end

  # @impl true
  # def handle_frame({:text, data}, state) do
  #   Logger.info(data)
  #   {:ok, state}
  # end

  # defp ping_heartbeat() do
  #   WebSockex.send_frame(self(), {:text, "PING\tshowroom"})
  #   Process.send_after(self(), :ping_heartbeat, :timer.minutes(1))
  # end

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

  # def start_link(room_url_key) do
  #   broadcast_key = fetch_bcsvr_key(room_url_key)
  #   IO.puts room_url_key
  #   IO.puts broadcast_key

  #   state = %{
  #     # "comment_count" => 0,
  #     "broadcast_key" => broadcast_key
  #   }

  #   IO.inspect state

  #   conn = 
  #     URI.parse(@wss_url)
  #     |> WebSockex.Conn.new(extra_headers: [{"Cookie", "_ga=GA1.2.2007546761.1507291116; _gid=GA1.2.792637120.1507291116"}], socket_connect_timeout: :timer.seconds(10), insecure: false, cacerts: ["/home/kenneth/Projects/sandbox/websockets/cacert-root.crt", "/home/kenneth/Projects/sandbox/websockets/cacert-class3.crt"])

  #   WebSockex.start_link(conn, __MODULE__, state, debug: [:trace, :log])
  # end

  # @impl true
  # def handle_connect(_conn, state) do
  #   Logger.info("Broadcast key: #{state["broadcast_key"]}")
  #   # Connect to channel chat
  #   WebSockex.send_frame(self(), {:text, "SUB\t#{state["broadcast_key"]}" })

  #   # Send a frame to the server to keep the connection alive
  #   ping_heartbeat()

  #   Logger.info("Connected!")
  #   {:ok, state}
  # end

  # @impl true
  # def handle_frame({:text, "MSG\t" <> data}, state) do
  #   json = data
  #          |> String.trim_leading("#{state["broadcast_key"]} ")
  #          |> Poison.decode!()

  #   Logger.info(json)

  #   {:ok, state}
  # end

  # @impl true
  # def handle_frame({:text, data}, state) do
  #   Logger.info(data)
  #   {:ok, state}
  # end

  # defp ping_heartbeat() do
  #   WebSockex.send_frame(self(), {:text, "PING\tshowroom"})
  #   Process.send_after(self(), :ping_heartbeat, :timer.minutes(1))
  # end

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

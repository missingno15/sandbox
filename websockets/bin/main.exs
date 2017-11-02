require IEx
room_url_key = System.argv()
               |> List.first()

IO.puts(room_url_key)
{:error, pid} = Websockets.start_link(room_url_key)


IEx.pry()

Process.sleep :timer.seconds(5)

IO.puts("exiting????")

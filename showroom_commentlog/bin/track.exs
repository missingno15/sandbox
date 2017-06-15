require IEx

track = fn room_url_key ->
  Showroom.Livestream.status(room_url_key)
  |> Map.get("room_id")
  |> Showroom.CommentLog.track()
end

IEx.pry()

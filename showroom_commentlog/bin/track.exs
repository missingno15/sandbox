require IEx

room_url_key = "48_Anna_Iriyama"

Showroom.Livestream.status(room_url_key) 
  |> Map.get("room_id") 
  |> Showroom.CommentLog.track()

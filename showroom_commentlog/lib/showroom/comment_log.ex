# require IEx
defmodule Showroom.CommentLog do
  @moduledoc """
  Documentation for Showroom.CommentLog.
  """

  @comment_endpoint "https://www.showroom-live.com/api/live/comment_log"

  def track(room_id, pointer \\ nil) do
    case HTTPoison.get!("#{@comment_endpoint}?room_id=#{room_id}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          json = Poison.decode!(body)

          comments = json["comment_log"] 
          [most_recent_comment | _tail] = comments

          display_comments(comments, pointer)

          track(room_id, most_recent_comment)
      {_, response} ->
        # if its not a 200 response, just inspect it
        IO.inspect(response)
        :timer.sleep(:timer.seconds(1))
        track(room_id, pointer)
    end
  end

  defp display_comments(comments, nil) do
    Enum.reverse(comments)
    |> Stream.each(&(&display_comment/1))
    |> Stream.run()
  end
  defp display_comments(comments, pointer) do
    # since Enum.find_index/2 is index based, the index value
    # itself gets us the correct amount of latest comments with
    # {Enum,Stream}.take/2
    index_of_last_latest_comment = Enum.find_index(comments, &(&1 == pointer))

    Enum.reverse(comments)
    |> Stream.take(index_of_last_latest_comment) 
    |> Stream.each(&(&display_comment/1))
    |> Stream.run()
  end

  def display_comment(%{"comment" => comment, "name" => user}) do
    case String.match?(comment, ~r/^([0-4]?[0-9]|[０-４]?[０-９]|50|５０)$/u) do
      true -> nil
      _ -> IO.puts("#{user}: #{comment}")
    end
  end
end

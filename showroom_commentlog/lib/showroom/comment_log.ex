require IEx
defmodule Showroom.CommentLog do
  @moduledoc """
  Documentation for Showroom.CommentLog.
  """

  @comment_endpoint "https://www.showroom-live.com/api/live/comment_log"

  def track(room_id, pointer \\ nil) do
    response = HTTPoison.get!("#{@comment_endpoint}?room_id=#{room_id}")
    json = Poison.decode!(response.body)

    comments = json["comment_log"] 

    [most_recent_comment | _tail] = comments

    IEx.pry

    if pointer == nil do

      Enum.reverse(comments)
      |> Stream.drop_while(fn comment -> 
        String.match?(comment["comment"], ~r/^([0-4]?[0-9]|[０-４]?[０-９]|50|５０)$/u)
      end)
      |> Stream.each(fn comment ->
        IO.puts("#{comment["name"]}: #{comment["comment"]}")
      end)
      |> Stream.run()
      
    else
      # since Enum.find_index/2 is index based, the index value
      # itself gets us the correct amount of latest comments with
      # {Enum,Stream}.take/2
      index_of_last_latest_comment = Enum.find_index(comments, &(&1 == pointer))

      Enum.reverse(comments)
      |> Stream.take(index_of_last_latest_comment) 
      |> Stream.drop_while(fn comment -> 
        String.match?(comment["comment"], ~r/^([0-4]?[0-9]|[０-４]?[０-９]|50|５０)$/u)
      end)
      |> Stream.each(fn comment ->
        IO.puts("#{comment["name"]}: #{comment["comment"]}")
      end)
      |> Stream.run()

    end

    :timer.sleep(:timer.seconds(1))
    track(room_id, most_recent_comment)
  end

  # defp matches_count_number?(comment) do
  #   String.match?(comment["comment"], ~r/^([0-4]?[0-9]|[０-４]?[０-９]|50|５０)$/u)
  # end
end

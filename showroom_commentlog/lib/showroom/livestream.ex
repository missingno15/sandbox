defmodule Showroom.Livestream do
  @moduledoc """
  Module for things related to a SHOWROOM livestream.
  """

  @room_status_endpoint "https://www.showroom-live.com/api/room/status"

  def status(room_url_key) do
    case HTTPoison.get("#{@room_status_endpoint}?room_url_key=#{room_url_key}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body }} ->
        Poison.decode!(body)
      {_, response} ->
        # if its not a 200 response, just inspect it
        IO.inspect response
    end
  end
end

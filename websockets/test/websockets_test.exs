defmodule WebsocketsTest do
  use ExUnit.Case
  doctest Websockets

  test "greets the world" do
    assert Websockets.hello() == :world
  end
end

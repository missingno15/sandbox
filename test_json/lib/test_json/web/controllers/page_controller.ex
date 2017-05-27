defmodule TestJSON.Web.PageController do
  use TestJSON.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

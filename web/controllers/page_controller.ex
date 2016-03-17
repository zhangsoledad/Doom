defmodule Doom.PageController do
  use Doom.Web, :controller

  import Openmaize.AccessControl
  plug :authorize, roles: ["admin", "user"]

  def index(conn, _params) do
    render conn, "index.html"
  end
end

defmodule Doom.PageController do
  use Doom.Web, :controller

  import Doom.Authorize
  def action(conn, _), do: authorize_action conn, ["admin", "user"], __MODULE__

  def index(conn, _params) do
    render conn, "index.html"
  end
end

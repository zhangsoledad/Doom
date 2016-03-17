defmodule Doom.SessionController do
  use Doom.Web, :controller

  import Doom.Authorize
  alias Openmaize.Login.Name

  plug :put_layout, false

  plug :scrub_params, "user" when action in [:create]

  plug Openmaize.Login, [unique_id: &Name.email_username/1] when action in [:create]
  plug Openmaize.Logout when action in [:delete]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, params) do
    handle_login conn, params
  end

  def delete(conn, params) do
    handle_logout conn, params
  end
end

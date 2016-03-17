defmodule Doom.SessionController do
  use Doom.Web, :controller
  alias Openmaize.{ConfirmTools, LoginTools}
  plug :put_layout, false

  plug :scrub_params, "user" when action in [:create]
  plug Openmaize.Login, [unique_id: &LoginTools.email_username/1] when action in [:create]
  plug Openmaize.Logout when action in [:delete]

  def new(conn, _params) do
    render(conn, "new.html")
  end
end

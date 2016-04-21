defmodule Doom.Api.HttpController do
  use Doom.Web, :controller

  import Doom.Api.Authorize

  def action(conn, _), do: authorize_action conn, ["admin", "user"], __MODULE__

  def req(conn, params) do

  end
end

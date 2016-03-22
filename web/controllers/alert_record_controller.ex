defmodule Doom.AlertRecordController do
  use Doom.Web, :controller

  import Doom.Authorize
  alias Doom.AlertRecord

  def action(conn, _), do: authorize_action conn, ["admin", "user"], __MODULE__

  def index(conn, params) do
    page = Map.get(params, "page", 1)
    alert_records = AlertRecord |> Repo.paginate(page: page)
    render(conn, "index.html", alert_records: alert_records)
  end
end

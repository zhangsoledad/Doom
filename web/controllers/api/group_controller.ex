defmodule Doom.Api.GroupController do
  use Doom.Web, :controller

  import Doom.Api.Authorize
  alias Doom.Group

  def action(conn, _), do: authorize_action conn, ["admin", "user"], __MODULE__

  def create(conn, %{"group" => group_params}) do
    changeset = Group.changeset(%Group{}, group_params)
    case Repo.insert(changeset) do
      {:ok, group} ->
        conn
        |> put_status(:created)
        |> render(Doom.GroupView, "create.json", group: group)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Doom.ChangesetView, "error.json", changeset: changeset)
    end
  end
end

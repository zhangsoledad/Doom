defmodule Doom.DashboardController do
  use Doom.Web, :controller

  import Doom.Authorize
  alias Doom.{Group,Task}

  def action(conn, _), do: authorize_action conn, ["admin", "user"], __MODULE__

  def index(conn, params) do
    groups = Repo.all(Group)
    page = Map.get(params, "page", 1)
    group = get_group(groups, params)
    group_id =  get_group_id(group)
    tasks = get_tasks(group, page)

    render(conn, "index.html", groups: groups, group_id: group_id, tasks: tasks)
  end

  defp get_group_id(nil) do
    1
  end

  defp get_group_id(group) do
    group.id
  end

  defp default_group([]) do
    nil
  end

  defp default_group(groups) do
    groups |> List.first
  end

  defp get_group(groups, params) do
    if pgroup_id = Map.get(params, "group_id") do
      group_id = pgroup_id |> String.to_integer
      groups |> Enum.find(&(&1.id == group_id))
    else
      groups |> default_group
    end
  end

  defp get_tasks(nil, page) do
    nil
  end

  defp get_tasks(group, page) do
    Ecto.assoc(group, :tasks)
    |> Repo.paginate(page: page)
  end
end

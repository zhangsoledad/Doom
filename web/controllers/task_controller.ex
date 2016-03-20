defmodule Doom.TaskController do
  use Doom.Web, :controller

  import Doom.Authorize
  alias Doom.{Task, Group}

  def action(conn, _), do: authorize_action conn, ["admin", "user"], __MODULE__
  plug :scrub_params, "task" when action in [:create, :update]

  def index(conn, params) do
    page = Map.get(params, "page", 1)
    tasks = Task |> Repo.paginate(page: page)
    render conn,"index.html", tasks: tasks
  end

  def new(conn, _params) do
    changeset = Task.changeset(%Task{})
    all_groups =  Repo.all from g in Group, select: {g.name, g.id}
    render(conn, "new.html", changeset: changeset, all_groups: all_groups)
  end

  def create(conn, %{"task" => task_params} = params) do
    groups = Repo.all(from(g in Group, where: g.id in ^params["group_ids"]))
    changeset = Task.changeset(%Task{}, process_task_params(task_params))
    |> Ecto.Changeset.put_assoc(:groups, groups)
    case Repo.insert(changeset) do
      {:ok, _task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Repo.get!(Task, id) |> Repo.preload(:groups)
    changeset = Task.changeset(task)
    all_groups =  Repo.all from g in Group, select: {g.name, g.id}
    render(conn, "edit.html", task: task, changeset: changeset, all_groups: all_groups)
  end

  def update(conn, %{"id" => id, "task" => task_params} = params) do
    all_groups =  Repo.all from g in Group, select: {g.name, g.id}
    groups = Repo.all(from(g in Group, where: g.id in ^params["group_ids"]))
    groups_changesets = Enum.map(groups, &Ecto.Changeset.change/1)

    task = Repo.get!(Task, id) |> Repo.preload(:groups)
    changeset = Task.changeset(task, process_task_params(task_params))
    |> Ecto.Changeset.put_assoc(:groups, groups_changesets)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset, all_groups: all_groups)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    Repo.delete!(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end

  defp process_task_params(task_params) do
    jheader = process_headers task_params["headers"]
    jparams = process_params task_params["params"]
    jexpect = process_expect task_params["expect"]
    Map.merge(task_params,
              %{"headers"=> jheader,
              "params"=> jparams,
              "expect"=> jexpect}
              )
  end

  defp process_headers(nil) do
    %{}
  end

  defp process_params(nil) do
    %{}
  end

  defp process_expect(nil) do
    %{}
  end

  defp process_headers(headers) when is_binary(headers) do
    Poison.Parser.parse! headers
  end

  defp process_params(params) when is_binary(params) do
    Poison.Parser.parse! params
  end

  defp process_expect(expect) when is_binary(expect) do
    Poison.Parser.parse! expect
  end

end

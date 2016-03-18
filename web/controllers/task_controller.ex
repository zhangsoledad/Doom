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

  def create(conn, %{"task" => task_params}) do
    changeset = Task.changeset(%Task{}, task_params)

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
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task)
    all_groups =  Repo.all from g in Group, select: {g.name, g.id}
    render(conn, "edit.html", task: task, changeset: changeset, all_groups: all_groups)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task, task_params)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end
end

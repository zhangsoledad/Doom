defmodule Doom.TaskControllerTest do
  use Doom.ConnCase

  alias Doom.Task
  @valid_attrs %{expect: "{\"show\":1}", interval: 42, name: "some content", params: nil, url: "some content" ,method: "get"}
  @invalid_attrs %{expect: "{1}", interval: 42, name: "some content", params: nil, url: "some content" ,method: "get"}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, task_path(conn, :index)
    assert html_response(conn, 200) =~ "All tasks"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, task_path(conn, :new)
    assert html_response(conn, 200) =~ "New Task"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    group = create(:group)
    conn = post conn, task_path(conn, :create), [task: @valid_attrs, group_ids: [group.id]]
    assert redirected_to(conn) == task_path(conn, :index)
    assert Repo.get_by(Task, name: @valid_attrs.name)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, task_path(conn, :create), task: @invalid_attrs
    assert redirected_to(conn) == task_path(conn, :new)
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    task = create(:task)
    conn = get conn, task_path(conn, :edit, task)
    assert html_response(conn, 200) =~ "Edit Task"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    task = create(:task)
    group = create(:group)
    conn = put conn, task_path(conn, :update, task), [task: @valid_attrs, group_ids: [group.id]]
    assert redirected_to(conn) == task_path(conn, :index)
    assert Repo.get(Task, task.id).name == @valid_attrs.name
  end
end

defmodule Doom.GroupControllerTest do
  use Doom.ConnCase

  alias Doom.Group

  @valid_attrs %{name: "test"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, group_path(conn, :index)
    assert html_response(conn, 200) =~ "All groups"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, group_path(conn, :new)
    assert html_response(conn, 200) =~ "New Group"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, group_path(conn, :create), group: @valid_attrs
    assert redirected_to(conn) == group_path(conn, :index)
    assert Repo.get_by(Group, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, group_path(conn, :create), group: @invalid_attrs
    assert html_response(conn, 200)
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    group = create(:group)
    conn = get conn, group_path(conn, :edit, group)
    assert html_response(conn, 200) =~ "Edit Group"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    group = create(:group)
    conn = put conn, group_path(conn, :update, group), group: %{name: "test_update"}
    assert redirected_to(conn) == group_path(conn, :edit, group)
    assert Repo.get_by(Group, name: "test_update")
  end
end

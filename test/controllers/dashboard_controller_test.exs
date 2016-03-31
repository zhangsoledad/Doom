defmodule Doom.DashboardControllerTest do
  use Doom.ConnCase

  alias Doom.Dashboard
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, dashboard_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing dashboard"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, dashboard_path(conn, :new)
    assert html_response(conn, 200) =~ "New dashboard"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, dashboard_path(conn, :create), dashboard: @valid_attrs
    assert redirected_to(conn) == dashboard_path(conn, :index)
    assert Repo.get_by(Dashboard, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, dashboard_path(conn, :create), dashboard: @invalid_attrs
    assert html_response(conn, 200) =~ "New dashboard"
  end

  test "shows chosen resource", %{conn: conn} do
    dashboard = Repo.insert! %Dashboard{}
    conn = get conn, dashboard_path(conn, :show, dashboard)
    assert html_response(conn, 200) =~ "Show dashboard"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, dashboard_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    dashboard = Repo.insert! %Dashboard{}
    conn = get conn, dashboard_path(conn, :edit, dashboard)
    assert html_response(conn, 200) =~ "Edit dashboard"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    dashboard = Repo.insert! %Dashboard{}
    conn = put conn, dashboard_path(conn, :update, dashboard), dashboard: @valid_attrs
    assert redirected_to(conn) == dashboard_path(conn, :show, dashboard)
    assert Repo.get_by(Dashboard, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    dashboard = Repo.insert! %Dashboard{}
    conn = put conn, dashboard_path(conn, :update, dashboard), dashboard: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit dashboard"
  end

  test "deletes chosen resource", %{conn: conn} do
    dashboard = Repo.insert! %Dashboard{}
    conn = delete conn, dashboard_path(conn, :delete, dashboard)
    assert redirected_to(conn) == dashboard_path(conn, :index)
    refute Repo.get(Dashboard, dashboard.id)
  end
end

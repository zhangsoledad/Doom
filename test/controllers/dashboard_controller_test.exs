defmodule Doom.DashboardControllerTest do
  use Doom.ConnCase

  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, dashboard_path(conn, :index)
    assert html_response(conn, 200) =~ "Dashboard"
  end
end

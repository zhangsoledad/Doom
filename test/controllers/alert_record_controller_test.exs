defmodule Doom.AlertRecordControllerTest do
  use Doom.ConnCase, async: true

  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, alert_record_path(conn, :index)
    assert html_response(conn, 200) =~ "Alert History"
  end
end

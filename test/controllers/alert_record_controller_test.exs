defmodule Doom.AlertRecordControllerTest do
  use Doom.ConnCase

  alias Doom.AlertRecord
  @valid_attrs %{}
  @invalid_attrs %{}

#  test "lists all entries on index", %{conn: conn} do
#    conn = get conn, alert_record_path(conn, :index)
#    assert html_response(conn, 200) =~ "Listing alert records"
#  end
#
#  test "renders form for new resources", %{conn: conn} do
#    conn = get conn, alert_record_path(conn, :new)
#    assert html_response(conn, 200) =~ "New alert record"
#  end
#
#  test "creates resource and redirects when data is valid", %{conn: conn} do
#    conn = post conn, alert_record_path(conn, :create), alert_record: @valid_attrs
#    assert redirected_to(conn) == alert_record_path(conn, :index)
#    assert Repo.get_by(AlertRecord, @valid_attrs)
#  end
#
#  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
#    conn = post conn, alert_record_path(conn, :create), alert_record: @invalid_attrs
#    assert html_response(conn, 200) =~ "New alert record"
#  end
#
#  test "shows chosen resource", %{conn: conn} do
#    alert_record = Repo.insert! %AlertRecord{}
#    conn = get conn, alert_record_path(conn, :show, alert_record)
#    assert html_response(conn, 200) =~ "Show alert record"
#  end
#
#  test "renders page not found when id is nonexistent", %{conn: conn} do
#    assert_error_sent 404, fn ->
#      get conn, alert_record_path(conn, :show, -1)
#    end
#  end
#
#  test "renders form for editing chosen resource", %{conn: conn} do
#    alert_record = Repo.insert! %AlertRecord{}
#    conn = get conn, alert_record_path(conn, :edit, alert_record)
#    assert html_response(conn, 200) =~ "Edit alert record"
#  end
#
#  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
#    alert_record = Repo.insert! %AlertRecord{}
#    conn = put conn, alert_record_path(conn, :update, alert_record), alert_record: @valid_attrs
#    assert redirected_to(conn) == alert_record_path(conn, :show, alert_record)
#    assert Repo.get_by(AlertRecord, @valid_attrs)
#  end
#
#  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
#    alert_record = Repo.insert! %AlertRecord{}
#    conn = put conn, alert_record_path(conn, :update, alert_record), alert_record: @invalid_attrs
#    assert html_response(conn, 200) =~ "Edit alert record"
#  end
#
#  test "deletes chosen resource", %{conn: conn} do
#    alert_record = Repo.insert! %AlertRecord{}
#    conn = delete conn, alert_record_path(conn, :delete, alert_record)
#    assert redirected_to(conn) == alert_record_path(conn, :index)
#    refute Repo.get(AlertRecord, alert_record.id)
#  end
end

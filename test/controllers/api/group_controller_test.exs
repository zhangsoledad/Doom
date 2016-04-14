defmodule Doom.Api.GroupControllerTest do
  use Doom.ConnCase, async: true

  @valid_attrs %{name: "test"}
  @invalid_attrs %{}

  @tag login: false
  test "without access token", %{conn: conn} do
    conn = post conn, api_group_path(conn, :create), group: @valid_attrs
    assert json_response(conn, 403)["message"] =~ "Invalid access token"
  end


  test "creates resource when data is valid", %{conn: conn} do
    conn = post conn, api_group_path(conn, :create), group: @valid_attrs
    assert json_response(conn, 201)["data"]["name"] == @valid_attrs.name
  end
end

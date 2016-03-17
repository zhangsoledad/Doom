defmodule Doom.TaskTest do
  use Doom.ModelCase

  alias Doom.Task

  @valid_attrs %{expect: %{}, interval: 42, name: "some content", params: %{}, url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end
end

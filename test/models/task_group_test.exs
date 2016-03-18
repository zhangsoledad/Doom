defmodule Doom.TaskGroupTest do
  use Doom.ModelCase

  alias Doom.TaskGroup

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TaskGroup.changeset(%TaskGroup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TaskGroup.changeset(%TaskGroup{}, @invalid_attrs)
    refute changeset.valid?
  end
end

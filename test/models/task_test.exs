defmodule Doom.TaskTest do
  use Doom.ModelCase

  alias Doom.Task

  @valid_attrs %{expect: %{}, interval: 42, name: "some content", params: %{}, url: "some content" ,method: "get"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with group assoc" do
    group = create(:group)
    changeset = Task.changeset(%Task{}, @valid_attrs) |> Ecto.Changeset.put_assoc(:groups, [group])
    assert changeset.valid?
  end
end

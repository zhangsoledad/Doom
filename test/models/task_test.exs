defmodule Doom.TaskTest do
  use Doom.ModelCase, async: true

  alias Doom.Task

  @valid_attrs %{"expect"=> "{\"show\":1}", "interval"=> 42, "name"=> "some content", "params"=> nil, "url" => "some content" ,"method"=> "get"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.save_changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with group assoc" do
    group = create(:group)
    changeset = Task.save_changeset(%Task{}, @valid_attrs) |> Ecto.Changeset.put_assoc(:groups, [group])
    assert changeset.valid?
  end
end

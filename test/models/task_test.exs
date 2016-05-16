defmodule Doom.TaskTest do
  use Doom.ModelCase, async: true

  alias Doom.Task

  @valid_attrs %{"expect"=> "{\"show\":1}", "interval"=> 42, "name"=> "some content", "params"=> nil, "url" => "some content" ,"method"=> "get", "type"=> "json"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.save_changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.save_changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid url" do
    too_long_url =  Stream.cycle([1]) |> Enum.take(200) |> Enum.join
    changeset = Task.changeset(%Task{}, %{@valid_attrs | "url" => too_long_url})
    refute changeset.valid?
  end

  test "changeset with group assoc" do
    group = insert_group
    changeset = Task.save_changeset(%Task{}, @valid_attrs) |> Ecto.Changeset.put_assoc(:groups, [group])
    assert changeset.valid?
  end
end

defmodule Doom.AlertRecordTest do
  use Doom.ModelCase, async: true

  alias Doom.AlertRecord

  @valid_attrs %{expect: %{}, task_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    task = insert_task
    changeset = AlertRecord.changeset(%AlertRecord{}, %{@valid_attrs| task_id: task.id} )
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AlertRecord.changeset(%AlertRecord{}, @invalid_attrs)
    refute changeset.valid?
  end
end

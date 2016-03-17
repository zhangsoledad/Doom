defmodule Doom.AlertRecordTest do
  use Doom.ModelCase

  alias Doom.AlertRecord

  @valid_attrs %{expect: %{}}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = AlertRecord.changeset(%AlertRecord{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AlertRecord.changeset(%AlertRecord{}, @invalid_attrs)
    refute changeset.valid?
  end
end

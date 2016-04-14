defmodule Doom.UserTest do
  use Doom.ModelCase, async: true

  alias Doom.User

  @valid_attrs %{email: "a@a.com", role: "admin", password: "zdw3240777"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "register_changeset with invalid attributes" do
    {key, _} = Openmaize.ConfirmEmail.gen_token_link(@valid_attrs.email)
    changeset = User.register_changeset(@valid_attrs, key)
    assert changeset.valid?
  end

  test "register_changeset with groups assoc" do
    group = create(:group)
    {key, _} = Openmaize.ConfirmEmail.gen_token_link(@valid_attrs.email)
    changeset = User.register_changeset(@valid_attrs, key) |> Ecto.Changeset.put_assoc(:groups, [group])
    assert changeset.valid?
  end
end

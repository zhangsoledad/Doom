defmodule Doom.User do
  use Doom.Web, :model

  schema "users" do
    field :email, :string
    field :username, :string
    field :role, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :confirmed_at, Ecto.DateTime
    field :confirmation_token, :string
    field :confirmation_sent_at, Ecto.DateTime
    field :reset_token, :string
    field :reset_sent_at, Ecto.DateTime
    field :bio, :string

    many_to_many :groups, Doom.Group, join_through: "users_groups"
    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, ~w(email role), ~w(username bio))
    |> validate_length(:username, min: 1, max: 30)
    |> unique_constraint(:email)
  end

  def register_changeset(params, key) do
    %Doom.User{}
    |> changeset(params)
    |> Openmaize.DB.add_password_hash(params)
    |> Openmaize.DB.add_confirm_token(key)
  end

  def reset_changeset(model, params, key) do
    model
    |> cast(params, ~w(email), [])
    |> Openmaize.DB.add_reset_token(key)
  end
end

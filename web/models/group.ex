defmodule Doom.Group do
  use Doom.Web, :model

  schema "groups" do
    field :name, :string
    field :tasks_count, :integer
    field :users_count, :integer
    many_to_many :users, Doom.User, join_through: "users_groups", on_delete: :delete_all
    many_to_many :tasks, Doom.Task, join_through: "tasks_groups", on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end

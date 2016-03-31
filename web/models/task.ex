defmodule Doom.Task do
  use Doom.Web, :model

  schema "tasks" do
    field :name, :string
    field :interval, :integer
    field :silent, :integer
    field :url, :string
    field :method, :string
    field :type, :string
    field :headers, :map
    field :params, :map
    field :expect, :map
    field :active, :boolean, default: true
    field :silence_at, Calecto.DateTimeUTC

    many_to_many :groups, Doom.Group, join_through: "tasks_groups", on_replace: :delete, on_delete: :delete_all
    timestamps
  end

  @required_fields ~w(name interval url expect method)
  @optional_fields ~w(active type params headers)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> cast_assoc(:groups)
  end
end

defmodule Doom.Task do
  use Doom.Web, :model

  schema "tasks" do
    field :name, :string
    field :interval, :integer
    field :url, :string
    field :method, :string
    field :params, :map
    field :expect, :map
    field :active, :boolean, default: true
    field :silence_at, Timex.Ecto.DateTime

    belongs_to :group, Doom.Group
    timestamps
  end

  @required_fields ~w(name interval url params expect)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end


  def init do

  end
end

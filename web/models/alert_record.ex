defmodule Doom.AlertRecord do
  use Doom.Web, :model

  schema "alert_records" do
    field :expect, :map
    field :result, :map
    field :status_code, :integer
    field :reason, :string

    belongs_to :task, Doom.Task
    timestamps
  end

  @required_fields ~w(expect)
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
end

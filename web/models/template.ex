defmodule Doom.Template do
  use Doom.Web, :model

  import Doom.Model.ParamsHelpers

  schema "templates" do
    field :name, :string
    field :url, :string
    field :method, :string
    field :type, :string
    field :headers, :map
    field :params, :map
    field :expect, :map

    timestamps
  end

  @required_fields ~w(name url expect type method)
  @optional_fields ~w(params headers)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end


  def save_changeset(model, params \\ %{}) do
    template_params = params |> process_json_params
    model |> changeset(template_params)
  end
end

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

  def save_changeset(model, params \\ %{}) do
    task_params = params |> process_task_params
    model |> changeset(task_params)
  end

  defp process_task_params(params) do
    new_headers =  params["headers"] |> process_json_field
    new_params = params["params"] |> process_json_field
    new_expect = params["expect"] |> process_expect
    Map.merge(params, %{ "headers"=> new_headers,
                         "params" => new_params,
                         "expect" => new_expect
                        })
  end

  defp process_json_field(nil) do
    %{}
  end

  defp process_json_field(field) when is_map(field) do
    Stream.zip( field["key"], field["value"] )
    |> Stream.filter( &(elem(&1, 0) != nil) )
    |> Enum.into(%{})
  end

  defp process_expect(expect) when is_binary(expect) do
    case Poison.Parser.parse(expect) do
      {:ok, value}->
        value
      {:error, _}->
        expect
    end
  end

  defp process_expect(expect) when is_map(expect) do
    expect
  end

  defp process_expect(_) do
    nil
  end
end

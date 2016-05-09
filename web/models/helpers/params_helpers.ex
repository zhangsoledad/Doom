defmodule Doom.Model.ParamsHelpers do
  def process_json_params(params) do
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

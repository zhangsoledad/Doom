defmodule Doom.Repo.Migrations.AddCountTriggerToGroups do
  use Ecto.Migration

  def up do
    File.cwd
    |> elem(1)
    |> Path.join("priv/repo/sql/group_count_trigger.sql")
    |> Path.expand
    |> File.read
    |> elem(1)
    |> String.split("--statement--")
    |> Enum.each(&execute(&1))
  end

  def down do

  end
end

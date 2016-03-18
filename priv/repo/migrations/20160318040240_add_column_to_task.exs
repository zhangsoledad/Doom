defmodule Doom.Repo.Migrations.AddColumnToTask do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :type, :string
      add :headers, :map
    end
  end
end

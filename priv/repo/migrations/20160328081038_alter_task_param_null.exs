defmodule Doom.Repo.Migrations.AlterTaskParamNull do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      modify :params, :map, null: true
    end
  end
end

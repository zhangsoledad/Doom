defmodule Doom.Repo.Migrations.AddCountToGroups do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      add :tasks_count, :integer, null: false, default: 0
      add :users_count, :integer, null: false, default: 0
    end
  end
end

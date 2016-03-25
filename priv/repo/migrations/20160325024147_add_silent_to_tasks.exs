defmodule Doom.Repo.Migrations.AddSilentToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :silent, :integer, null: false, default: 30
    end
  end
end

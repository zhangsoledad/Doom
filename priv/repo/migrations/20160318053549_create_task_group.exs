defmodule Doom.Repo.Migrations.CreateTaskGroup do
  use Ecto.Migration

  def change do
    create table(:tasks_groups) do
      add :group_id, references(:groups)
      add :task_id, references(:tasks)
      timestamps
    end

    create index(:tasks_groups, [:group_id, :task_id ], unique: true)
  end
end

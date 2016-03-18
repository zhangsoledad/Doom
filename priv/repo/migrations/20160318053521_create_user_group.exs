defmodule Doom.Repo.Migrations.CreateUserGroup do
  use Ecto.Migration

  def change do
    create table(:users_groups) do
      add :group_id, references(:groups)
      add :user_id, references(:users)
      timestamps
    end

    create index(:users_groups, [:group_id, :user_id ], unique: true)
  end
end

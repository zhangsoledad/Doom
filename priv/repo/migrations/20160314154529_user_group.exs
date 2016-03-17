defmodule Doom.Repo.Migrations.UserGroup do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :group_id, references(:groups)
    end
  end
end

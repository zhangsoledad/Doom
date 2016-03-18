defmodule Doom.Repo.Migrations.RefactoryAssociation do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :group_id
    end

    alter table(:tasks) do
      remove :group_id
    end
  end
end

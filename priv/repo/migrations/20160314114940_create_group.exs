defmodule Doom.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :name, :string, null: false
      timestamps
    end

  end
end

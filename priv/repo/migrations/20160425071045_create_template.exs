defmodule Doom.Repo.Migrations.CreateTemplate do
  use Ecto.Migration

  def change do
    create table(:templates) do
      add :name, :string, null: false, limit: 50
      add :url, :string, null: false
      add :type, :string
      add :method, :string
      add :params, :map
      add :headers, :map
      add :expect, :map, null: false
      timestamps
    end

    create index(:templates, [:name], unique: true)
  end
end

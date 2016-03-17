defmodule Doom.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :interval, :integer, default: 15, null: false
      add :url, :string, null: false
      add :method, :string, null: false
      add :params, :map, null: false
      add :expect, :map, null: false
      add :active, :boolean, default: true, null: false
      add :silence_at, :datetime
      add :group_id, references(:groups)
      timestamps
    end
    create index(:tasks, [:name])
  end
end

defmodule Doom.Repo.Migrations.CreateAlertRecord do
  use Ecto.Migration

  def change do
    create table(:alert_records) do
      add :task_id, references(:tasks)
      add :expect, :map
      add :result, :map
      add :status_code, :integer
      add :reason, :string

      timestamps
    end

  end
end

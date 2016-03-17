defmodule Doom.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :password_hash, :string
      add :role, :string
      add :confirmed_at, :datetime
      add :confirmation_token, :string
      add :confirmation_sent_at, :datetime
      add :reset_token, :string
      add :reset_sent_at, :datetime
      add :bio, :string
      timestamps
    end

    create index(:users, [:email], unique: true)
  end
end

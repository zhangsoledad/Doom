# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Doom.Repo.insert!(%Doom.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

users = [
  %{
    email: "787953403@qq.com",
    username: "soledad",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad."
  },
  %{
    email: "a@souche.com",
    username: "a",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad."
  },
  %{
    email: "b@souche.com",
    username: "b",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad."
  },
  %{
    email: "c@souche.com",
    username: "c",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad."
  },
  %{
    email: "d@souche.com",
    username: "d",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad."
  },
  %{
    email: "e@souche.com",
    username: "e",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad."
  },
  %{
    email: "f@souche.com",
    username: "f",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad."
  },
  %{
    email: "g@souche.com",
    username: "g",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad."
  }
]

Doom.Repo.insert_all User, users


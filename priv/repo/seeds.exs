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
  %Doom.User{
    email: "787953403@qq.com",
    username: "soledad",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "admin",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad.",
    groups: [ %Doom.Group{name: "admin"} ]
  },
  %Doom.User{
    email: "a@souche.com",
    username: "a",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "user",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad.",
    groups: [ %Doom.Group{name: "group-a"} ]
  },
  %Doom.User{
    email: "b@souche.com",
    username: "b",
    password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
    role: "user",
    confirmed_at: Ecto.DateTime.utc,
    bio: "Lord Soledad.",
    groups: [ %Doom.Group{name: "group-b"} ]
  }
]

for user <- users do
  user |> Doom.Repo.insert!
end

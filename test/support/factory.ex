defmodule Doom.Factory do
  use ExMachina.Ecto, repo: Doom.Repo
  alias Doom.{User,Group,Task}

  def factory(:user) do
    %User{
      username: "soledad",
      role: "admin",
      confirmed_at: Ecto.DateTime.utc,
      password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      bio: ""
    }
  end

  def factory(:group) do
    %Group{
      name: "test"
    }
  end

  def factory(:task) do
    %Task{
      name: "test",
      expect: %{},
      interval: 42,
      params: %{},
      method: "get",
      url: "http://fuckbaidu.com"
    }
  end
end

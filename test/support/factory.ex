defmodule Doom.Factory do
  use ExMachina.Ecto, repo: Doom.Repo
  alias Doom.{User,Group}

  def factory(:user) do
    %User{
      username: "soledad",
      role: "admin",
      email: sequence(:email, &"email-#{&1}@example.com"),
      bio: ""
    }
  end

  def factory(:group) do
    %Group{
      name: "test"
    }
  end
end

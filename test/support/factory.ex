defmodule Doom.Factory do 
  alias Doom.{User,Group,Task,Repo}

  def insert_user do
    %User{
      username: "soledad",
      role: "admin",
      confirmed_at: Ecto.DateTime.utc,
      password_hash: Comeonin.Bcrypt.hashpwsalt("1234567"),
      email: "#{random_string(6)}@exmple.com",
      bio: ""
    } |> Repo.insert!
  end

  def insert_group do
    %Group{
      name: "#{random_string(6)}"
    } |> Repo.insert!
  end

  def insert_task do
    %Task{
      name: "#{random_string(6)}",
      expect: %{},
      interval: 42,
      params: %{},
      method: "get",
      url: "http://fuckbaidu.com"
    } |> Repo.insert!
  end
  
  
  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end

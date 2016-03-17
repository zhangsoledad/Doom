defmodule Doom.AdminController do
  use Doom.Web, :controller

  import Openmaize.AccessControl

  alias Openmaize.ConfirmTools
  alias Doom.{Mailer, User}

  plug :authorize, roles: ["admin"]
  plug :scrub_params, "user" when action in [:register_user]

  def index(conn, params) do
    page = Map.get(params, "page", 1)
    users = User |> Repo.paginate(page: page)
    render conn,"index.html", users: users
  end

  def register_user(conn, %{"user" => %{"email" => email} = user_params}) do
    {key, link} = ConfirmTools.gen_token_link(email)
    changeset = user_params
    |> Map.put_new("username", user_params["email"] |> String.split("@") |> hd)
    |> User.register_changeset(key)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        Mailer.ask_confirm([email], link)
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: admin_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:errors, changeset.errors)
        |> redirect(to: admin_path(conn, :index))
    end
  end
end

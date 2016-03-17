defmodule Doom.AdminController do
  use Doom.Web, :controller

  import Doom.Authorize

  alias Openmaize.ConfirmEmail
  alias Doom.{Mailer, User}

  plug :scrub_params, "user" when action in [:register_user]

  def action(conn, _), do: authorize_action conn, ["admin"], __MODULE__

  def index(conn, params) do
    page = Map.get(params, "page", 1)
    users = User |> Repo.paginate(page: page)
    render conn,"index.html", users: users
  end

  def register_user(conn, %{"user" => %{"email" => email} = user_params}) do
    {key, link} = ConfirmEmail.gen_token_link(email)
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

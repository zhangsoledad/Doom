defmodule Doom.Admin.UserController do
  use Doom.Web, :controller

  import Doom.Authorize

  alias Openmaize.ConfirmEmail
  alias Doom.{Mailer, User, Group}

  plug :scrub_params, "user" when action in [:create]

  def action(conn, _), do: authorize_action conn, ["admin"], __MODULE__

  def index(conn, params) do
    page = Map.get(params, "page", 1)
    users = User |> Repo.paginate(page: page)
    all_groups =  Repo.all from g in Group, select: {g.name, g.id}
    changeset = User.changeset(%User{})
    render conn,"index.html", users: users, all_groups: all_groups, changeset: changeset
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render conn, "edit_user.html", user: user, changeset: changeset
  end

  def update(conn, %{ "id"=> id } = user_params) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
     {:ok, user} ->
       conn
       |> put_flash(:info, "Group updated successfully.")
       |> redirect(to: admin_user_path(conn, :edit, user))
     {:error, changeset} ->
       render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def create(conn, %{"user" => %{"email" => email} = user_params} = params) do
    groups = Repo.all(from(g in Group, where: g.id in ^params["group_ids"]))
    {key, link} = ConfirmEmail.gen_token_link(email)
    changeset = user_params
    |> Map.put_new("username", user_params["email"] |> String.split("@") |> hd)
    |> User.register_changeset(key)
    |> Ecto.Changeset.put_assoc(:groups, groups)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        Mailer.ask_confirm([email], link)
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: admin_user_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:errors, changeset.errors)
        |> redirect(to: admin_user_path(conn, :index))
    end
  end
end

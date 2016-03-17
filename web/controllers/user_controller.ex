defmodule Doom.UserController do
  use Doom.Web, :controller

  import Doom.Authorize
  alias Openmaize.ConfirmEmail
  alias Doom.{Mailer, User}

  plug :put_layout, false

  plug :scrub_params, "user" when action in [:create, :update]

  plug Openmaize.ConfirmEmail, [] when action in [:confirm]
  plug Openmaize.ResetPassword, [] when action in [:reset_password]

  def ask_reset(conn, _params) do
    render(conn, "ask_reset.html")
  end

  def post_reset(conn, %{"user" => %{"email" => email} = user_params}) do
    case Repo.get_by(User, email: email) do
      nil ->
        conn
        |> put_flash(:error, "Email not register.")
        |> redirect(to: "/login")
      user ->
        {key, link} = ConfirmEmail.gen_token_link(email)

        user
        |> User.reset_changeset(user_params, key)
        |> Repo.update

        Mailer.ask_reset([email], link)
        conn
        |> put_flash(:info, "Check your inbox for reset your password.")
        |> redirect(to: "/login")
    end
  end

  def reset(conn, %{"email" => email, "key" => key}) do
    render conn, "reset_form.html", email: email, key: key
  end

  def confirm(conn, params) do
    handle_confirm conn, params
  end

  def reset_password(conn, params) do
    handle_reset conn, params
  end
end

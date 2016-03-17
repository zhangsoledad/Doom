defmodule Doom.Authorize do
  import Plug.Conn
  import Phoenix.Controller

  @redirects  %{"login" => "/login", "admin" => "/", "user" => "/", "logout" => "/login"}

  @doc """
  Custom action that can be used to override the `action` function in any
  Phoenix controller.

  This function checks for a `current_user` value, and if it finds it, it
  then checks that the user's role is in the list of allowed roles. If
  there is no current_user, the `unauthenticated` function is called, and
  if the user's role is not in the list of allowed roles, the `unauthorized`
  function is called.

  ## Examples

  First, import this module in the controller, and then add the following line:

      def action(conn, _), do: authorize_action conn, ["admin", "user"], __MODULE__

  This command will only allow connections for users with the "admin" and "user"
  roles.

  You will also need to change the other functions in the controller to accept
  a third argument, which is the current user. For example, change:
  `def index(conn, params) do` to: `def index(conn, params, user) do`
  """
  def authorize_action(%Plug.Conn{assigns: %{current_user: nil}} = conn, _, _) do
    unauthenticated conn
  end

  def authorize_action(%Plug.Conn{assigns: %{current_user: current_user},
                                  params: params} = conn, roles, module) do
    if current_user.role in roles do
      apply(module, action_name(conn), [conn, params])
    else
      unauthorized conn, current_user
    end
  end

  def unauthenticated(conn, message \\ "You need to log in to view this page") do
    conn |> redirect(to: "/login") |> halt
  end

  def unauthorized(conn, current_user, message \\ "You are not authorized to view this page") do
    conn |> put_flash(:error, message) |> redirect(to: @redirects[current_user.role]) |> halt
  end

  def role_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    unauthenticated conn
  end

  def role_check(%Plug.Conn{assigns: %{current_user: current_user}} = conn, opts) do
    roles = Keyword.get(opts, :roles, [])
    current_user.role in roles and conn || unauthorized conn, current_user
  end

  def id_check(%Plug.Conn{assigns: %{current_user: nil}} = conn, _opts) do
    unauthenticated conn
  end

  def id_check(%Plug.Conn{params: %{"id" => id},
              assigns: %{current_user: %{id: current_id} = current_user}} = conn, _opts) do
    id == to_string(current_id) and conn || unauthorized conn, current_user
  end

  def handle_login(%Plug.Conn{private: %{openmaize_error: message}} = conn, _params) do
    unauthenticated conn, message
  end

  def handle_login(%Plug.Conn{private:
                            %{openmaize_user: %{role: role}}} = conn, _params) do
    conn |> put_flash(:info, "You have been logged in") |> redirect(to: @redirects[role])
  end


  def handle_logout(%Plug.Conn{private: %{openmaize_info: message}} = conn, _params) do
    conn |> put_flash(:info, message) |> redirect(to: "/login")
  end


  def handle_confirm(%Plug.Conn{private: %{openmaize_error: message}} = conn, _params) do
    unauthenticated conn, message
  end

  def handle_confirm(%Plug.Conn{private: %{openmaize_info: message}} = conn, _params) do
    conn |> put_flash(:info, message) |> redirect(to: "/login")
  end

  def handle_reset(%Plug.Conn{private: %{openmaize_error: message}} = conn,
                  %{"user" => %{"email" => email, "key" => key}}) do
    conn
    |> put_flash(:error, message)
    |> render("reset_form.html", email: email, key: key)
  end

  def handle_reset(%Plug.Conn{private: %{openmaize_info: message}} = conn, _params) do
    conn |> put_flash(:info, message) |> redirect(to: "/login")
  end
end

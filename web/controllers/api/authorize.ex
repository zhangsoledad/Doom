defmodule Doom.Api.Authorize do
  import Plug.Conn
  import Phoenix.Controller

  def authorize_action(%Plug.Conn{assigns: %{current_user: nil}} = conn, _, _) do
    unauthenticated conn
  end

  def authorize_action(%Plug.Conn{assigns: %{current_user: current_user},
                                  params: params} = conn, roles, module) do
    if current_user.role in roles do
      apply(module, action_name(conn), [conn, params])
    else
      unauthenticated conn
    end
  end

   defp unauthenticated(conn, message \\ "Invalid access token") do
     conn
     |> put_status(:forbidden)
     |> render(Doom.ErrorView, "403.json", message: message)
   end
end

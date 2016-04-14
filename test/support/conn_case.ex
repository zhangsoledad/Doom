defmodule Doom.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  import Openmaize.JWT.Create
  import Doom.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Doom.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]

      import Doom.Router.Helpers
      import Doom.Factory

      # The default endpoint for testing
      @endpoint Doom.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Doom.Repo)

    conn = Phoenix.ConnTest.conn()

    login = Map.get(tags, :login, true)

    if login do
      user = create(:user)
      user_map = %{id: user.id, username: user.username, role: user.role}

      {:ok, user_token} = user_map |> generate_token({0, 7200})

      conn = conn |> Phoenix.ConnTest.put_req_cookie("access_token", user_token)
    end

    {:ok, conn: conn}
  end
end

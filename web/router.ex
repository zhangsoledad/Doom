defmodule Doom.Router do
  use Doom.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Openmaize.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Doom do
    pipe_through :browser # Use the default browser stack

    get "/", DashboardController, :index

    resources "/users", UserController, only: [:update]
    get "/confirm", UserController, :confirm
    get "/ask_reset", UserController, :ask_reset
    post "/post_reset", UserController, :post_reset
    get "/reset", UserController, :reset
    post "/reset_password", UserController, :reset_password

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete


    resources "/groups", GroupController
    resources "/tasks", TaskController
    resources "/alert_records", AlertRecordController, only: [:index]
  end

   scope "/admin", Doom.Admin, as: :admin do
     pipe_through :browser

     resources "/users", UserController
   end

  # Other scopes may use custom stacks.
  # scope "/api", Doom do
  #   pipe_through :api
  # end
end

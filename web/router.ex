defmodule PushApiServer.Router do
  use PushApiServer.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PushApiServer do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index, as: :root

    get "/signup", RegistrationController, :new, as: :signup
    get "/signin", SessionController, :new, as: :signin
    delete "/signout", SessionController, :delete, as: :signout

    resources "/registrations", RegistrationController, only: [:new, :create]
    resources "/passwords", PasswordController
    resources "/sessions", SessionController

    resources "/users", UserController
    resources "/projects", ProjectController
    resources "/pushes", PushController, only: [:index, :show, :delete]

    resources "/projects", ProjectController
  end

  # Other scopes may use custom stacks.
  scope "/api", PushApiServer do
    pipe_through :api
    resources "/pushes", API.PushController
  end
end

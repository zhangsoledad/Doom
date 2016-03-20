defmodule Doom do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Doom.Endpoint, []),
      # Start the Ecto repository
      supervisor(Doom.Repo, []),

      supervisor(Task.Supervisor, [[name: Doom.TasksSupervisor]]),
      # Here you could define other workers and supervisors as children
      worker(Doom.Mailer.Server, [], restart: :transient)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Doom.Supervisor]
    result = Supervisor.start_link(children, opts)

    Doom.Monitor.Job.init
    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Doom.Endpoint.config_change(changed, removed)
    :ok
  end
end

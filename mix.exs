defmodule Doom.Mixfile do
  use Mix.Project

  def project do
    [app: :doom,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Doom, []},
     applications: applications(Mix.env)]
  end

  defp applications(:test) do
    [:ex_machina | applications(:dev)]
  end

  defp applications(_) do
    [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
     :phoenix_ecto, :postgrex, :quantum, :httpoison, :not_qwerty123, :openmaize,
     :calendar, :calecto, :phoenix_calendar]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.1.4"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0.0-beta"},
     {:phoenix_html, "~> 2.5.1"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:quantum, "~> 1.7.0"},
     {:exrm, "~> 1.0.2"},
     {:phoenix_calendar, "~> 0.1.2"},
     {:calecto, "~> 0.5.2"},
     {:calendar, "~> 0.13"},
     {:httpoison, "~> 0.8.1"},
     {:not_qwerty123, "~> 1.1"},
     {:openmaize, github: "zhangsoledad/openmaize"},
     {:scrivener, github: "zhangsoledad/scrivener"},
     {:mailman, "~> 0.2.2"},
     {:logger_file_backend, "~> 0.0.7"},
     {:ex_machina, "~> 0.6.1", only: :test},
     {:credo, "~> 0.3", only: [:dev, :test]}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"]]
  end
end

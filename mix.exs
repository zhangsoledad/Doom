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
     test_coverage: [tool: ExCoveralls],
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
    applications(:dev)
  end

  defp applications(_) do
    [:phoenix, :phoenix_html, :phoenix_pubsub, :cowboy, :logger, :gettext,
     :phoenix_ecto, :postgrex, :quantum, :httpoison, :not_qwerty123, :openmaize,
     :calendar, :calecto, :scrivener, :floki, :mailman,
     :alchemic_avatar, :alchemic_pinyin]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_pubsub, "~> 1.0.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:quantum, "~> 1.7.0"},
     {:exrm, "~> 1.0.6"},
     {:calecto, "~> 0.16.0"},
     {:calendar, "~> 0.16.0"},
     {:httpoison, "~> 0.9.0"},
     {:not_qwerty123, "~> 1.1"},
     {:floki, "~> 0.9"},
     {:dialyze, "~> 0.2.0", only: :dev},
     {:alchemic_pinyin, "~> 0.1.0"},
     {:alchemic_avatar, "~> 0.1.2"},
     {:scrivener_ecto, "~> 1.0"},
     {:openmaize, github: "zhangsoledad/openmaize"},
     {:mailman, github: "zhangsoledad/mailman"},
     #{:ex_machina, "~> 1.0.0-beta.1", github: "thoughtbot/ex_machina", only: :test},
     {:excoveralls, "~> 0.5", only: :test},
     {:inch_ex, ">= 0.0.0", only: [:dev, :test]},
     {:credo, "~> 0.4", only: [:dev, :test]}]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end

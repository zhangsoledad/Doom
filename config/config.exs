# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :doom, Doom.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "HhNlyOvbqbzXml3gQKcej4oDA5Vixzz8q68YB42cRcG+glvC6RVv4yYwiEQVivZ4",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Doom.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :doom, Doom.Gettext, default_locale: "zh_CN"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :openmaize,
  user_model: Doom.User,
  repo: Doom.Repo,
  password_strength: [min_length: 6, extra_chars: false]

config :doom, ecto_repos: [Doom.Repo]

import_config "#{Mix.env}.exs"
import_config "mailer.exs"

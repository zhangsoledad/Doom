use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :doom, Doom.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :doom, Doom.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "doom_test",
  password: "doom_test",
  database: "doom_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

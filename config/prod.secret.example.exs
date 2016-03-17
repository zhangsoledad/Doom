use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :doom, Doom.Endpoint,
  secret_key_base: "vX+QaI3HFh1BlKYm35yq4zo0MnkHdsg9aLVt+6btLO0kklfwiHYoiY8RPW+XZ+TD"

# Configure your database
config :doom, Doom.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "doom_prod",
  password: "doom_prod",
  database: "doom_prod",
  pool_size: 20

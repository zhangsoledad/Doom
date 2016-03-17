defmodule Doom.Repo do
  use Ecto.Repo, otp_app: :doom
  use Scrivener, page_size: 1
end

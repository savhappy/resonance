defmodule Resonance.Repo do
  use Ecto.Repo,
    otp_app: :resonance,
    adapter: Ecto.Adapters.Postgres
end

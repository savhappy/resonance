defmodule Resonance.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ResonanceWeb.Telemetry,
      Resonance.Repo,
      {DNSCluster, query: Application.get_env(:resonance, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Resonance.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Resonance.Finch},
      # Start a worker by calling: Resonance.Worker.start_link(arg)
      # {Resonance.Worker, arg},
      # Start to serve requests, typically the last entry
      ResonanceWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Resonance.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ResonanceWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule PointPulse.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PointPulseWeb.Telemetry,
      PointPulse.Repo,
      {DNSCluster, query: Application.get_env(:point_pulse, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PointPulse.PubSub},
      # Start a worker by calling: PointPulse.Worker.start_link(arg)
      # {PointPulse.Worker, arg},
      # Start to serve requests, typically the last entry
      PointPulseWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PointPulse.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PointPulseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

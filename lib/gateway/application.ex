defmodule Gateway.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GatewayWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Gateway.PubSub},
      # Start the Endpoint (http/https)
      GatewayWeb.Endpoint,
      # Start a worker by calling: Gateway.Worker.start_link(arg)
      # {Gateway.Worker, arg}
      # {Gateway.Publisher, :ok}
      {GatewayPipeline.StageQueue, :ok},
      {GatewayPipeline.StagePublisher, :ok}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Gateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GatewayWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

defmodule VileCards.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      VileCardsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: VileCards.PubSub},
      # Start the Endpoint (http/https)
      VileCardsWeb.Endpoint,
      # Start a worker by calling: VileCards.Worker.start_link(arg)
      # {VileCards.Worker, arg}
      {Registry, keys: :unique, name: VileCards.Runtime.GameRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: VileCards.Runtime.GameSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VileCards.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VileCardsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

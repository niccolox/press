defmodule Assembled.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    apps = [
      AssembledWeb.Telemetry,
      Assembled.Repo,
      {Phoenix.PubSub, name: Assembled.PubSub},
      {Finch, name: Assembled.Finch},
      AssembledWeb.Endpoint,
      # {Assembled.Worker, arg} # Assembled.Worker.start_link(arg)
    ]

    apps = case Mix.env do
      :test -> apps
      :dev -> apps ++
        [{Desktop.Window, [
          app: :assembled,
          id: AssembledScreen,
          url: &AssembledWeb.Endpoint.url/0,
        ]}]
      _ -> apps
    end

    Supervisor.start_link(apps,
      [strategy: :one_for_one, name: Assembled.Supervisor])
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AssembledWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end

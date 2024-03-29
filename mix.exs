defmodule Assembled.MixProject do
  use Mix.Project

  def project do
    [
      app: :assembled,
      version: "0.1.0",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      compilers: Mix.compilers() ++ [:surface]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Assembled.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(:dev), do: ["lib"] ++ catalogues()
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:deep_merge, "~> 1.0"},
      {:desktop, "~> 1.5"},
      {:dotenv, "~> 3.0.0", only: [:dev, :test]},
      {:ecto_sql, "~> 3.10"},
      {:esbuild, "~> 0.7", runtime: Mix.env() == :dev},
      {:ex_unit_notifier, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.20"},
      {:httpoison, "~> 2.1.0"},
      {:jason, "~> 1.2"},
      {:makeup_elixir, "~> 0.16"},
      {:makeup_erlang, "~> 0.1"},
      {:nimble_publisher, "~> 1.0"},
      {:phoenix, "~> 1.7.10"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.19.0"},
      {:plug_cowboy, "~> 2.5"},
      {:poison, "~> 5.0"},
      {:postgrex, ">= 0.0.0"},
      {:surface, "~> 0.11"},
      {:surface_bulma, "~> 0.5"},
      {:surface_catalogue, "~> 0.6"},
      {:swoosh, "~> 1.3"},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
    ]
  end

  def catalogues do
    [
      "priv/catalogue",
      "deps/surface/priv/catalogue",
      "deps/surface_bulma/priv/catalogue",
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "assets.setup", "assets.build"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "tailwind lib", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "tailwind lib --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end

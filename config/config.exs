# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config
import_config("contexts.exs")

config :assembled,
  ecto_repos: [Assembled.Repo]

# Configures the endpoint
config :assembled, AssembledWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: AssembledWeb.ErrorHTML, json: AssembledWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Assembled.PubSub,
  live_view: [signing_salt: "WN1TlR6p"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :assembled, Assembled.Mailer, adapter: Swoosh.Adapters.Local

node = [
  cd: Path.expand("../assets", __DIR__),
  env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)},
]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: node ++ [ args: ~w( js/app.js --bundle --target=es2017
      --outdir=../priv/static/assets --external:/fonts/* --external:/images/* ) ],
  catalogue: node ++ [ args: ~w( ../deps/surface_catalogue/assets/js/app.js
    --bundle --target=es2016 --minify --outdir=../priv/static/assets/catalogue) ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.7",
  default: [
    cd: Path.expand("../assets", __DIR__),
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ) ],
  lib: [
    cd: Path.expand("../assets", __DIR__),
    args: ~w(
      --config=tailwind.config.js
      --input=css/lib.css
      --output=../priv/static/assets/lib.css
    ) ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :assembled, :generators,
  migration: true,
  binary_id: true,
  timestamp_type: :utc_datetime,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

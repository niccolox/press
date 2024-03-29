import Config

# Configure your database
config :assembled, Assembled.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "127.0.0.1",
  database: "assembled_local",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :assembled, AssembledWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4444],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "7V8tAXy0Gh2gY3+8zZ0YKJUgbnyEOIel3M5lQRDny4sCz/mx2lSa/pdGRmZ0OkEO",
  watchers: [
    esbuild: { Esbuild, :install_and_run, [ :default, ~w(--sourcemap=inline --watch) ]},
    esbuild: { Esbuild, :install_and_run, [ :catalogue, ~w(--sourcemap=inline --watch) ]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# Mix task:
#
#     mix phx.gen.cert
#
# Run `mix help phx.gen.cert` for more information.
#
# The `http:` config above can be replaced with:
#
#     https: [
#       port: 4001,
#       cipher_suite: :strong,
#       keyfile: "priv/cert/selfsigned_key.pem",
#       certfile: "priv/cert/selfsigned.pem"
#     ],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :assembled, AssembledWeb.Endpoint,
  reloadable_compilers: [:gettext, :elixir, :app, :surface],
  live_reload: [
    reload_page_on_css_changes: true,
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"priv/catalogue/.*(ex)$",
      ~r"lib/assembled_web/(controllers|live|components)/.*(ex|heex|sface|js)$",
      ~r"page/.*(md)$",
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :assembled, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

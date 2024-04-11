# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :point_pulse,
  ecto_repos: [PointPulse.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :point_pulse, PointPulseWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [
    formats: [json: PointPulseWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PointPulse.PubSub,
  live_view: [signing_salt: "J+q6Wj8x"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :cors_plug,
  origin: ["*"],
  max_age: 86400,
  methods: ["GET", "POST", "DELETE", "PATCH"],
  headers: [
    "Authorization",
    "Content-Type",
    "Accept",
    "Origin",
    "User-Agent",
    "DNT",
    "Cache-Control",
    "X-Mx-ReqToken",
    "Keep-Alive",
    "X-Requested-With",
    "If-Modified-Since",
    "X-CSRF-Token"
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian.DB,
  repo: PointPulse.Repo,
  schema_name: "guardian_tokens",
  sweep_interval: 600

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

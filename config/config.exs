# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

config :chat, Chat.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "chat_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"


# General application configuration
config :chat,
  ecto_repos: [Chat.Repo]

# Configures the endpoint
config :chat, Chat.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hPPEY8R5T07xk97R5kSwRwkvMGXOQuwI6YMxa1Q6qnChuRdpk3yfhZxGo1N16MVs",
  render_errors: [view: Chat.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chat.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "3fac233645f813c95f8f",
  client_secret: "cebaca28fff813a20e1a5542d3339978b4270ca7"

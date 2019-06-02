use Mix.Config
# Print only warnings and errors during test
config :logger, level: :warn
config :info_sys, :wolfram,
  app_id: "1234",
  http_client: InfoSys.Test.HTTPClient

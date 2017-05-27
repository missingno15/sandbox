use Mix.Config

config :test_json, TestJSON.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "test_json_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"


config :test_json, ecto_repos: [TestJSON.Repo]

defmodule Websockets.Mixfile do
  use Mix.Project

  def project do
    [
      app: :websockets,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :httpoison
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:socket, "~> 0.3.12"},
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1"}
    ]
  end
end

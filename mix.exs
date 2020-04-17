defmodule Gmb.MixProject do
  use Mix.Project

  def project do
    [
      app: :gmb,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison, :jason],
      mod: {Gmb.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.8", only: [:dev, :test]},
      {:excoveralls, "~> 0.10", only: :test},
      {:httpoison, "~> 1.5.1"},
      {:jason, "~> 1.0"},
      {:mockery, "~> 2.1", runtime: false},
      {:mulligan, "~> 0.1.1", organization: "podium"},
      {:poison, "~> 3.1"},
      {:uuid, "~> 1.1"}
    ]
  end
end

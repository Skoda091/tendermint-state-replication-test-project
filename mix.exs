defmodule TendermintStateReplicationTestProject.MixProject do
  use Mix.Project
  alias TendermintStateReplicationTestProject.Application

  def project do
    [
      app: :tendermint_state_replication_test_project,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Application, []},
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gpb, git: "https://github.com/tomas-abrahamsson/gpb", tag: "4.0.2"},
      {:ranch, git: "https://github.com/ninenines/ranch", tag: "1.3.2"},
      {:abci_server, github: "KrzysiekJ/abci_server", tag: "v0.3.0"},
      {:merkle_tree, "~> 1.2.1"},
      {:httpoison, "~> 1.0"}
    ]
  end
end

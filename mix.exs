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
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:gpb, git: "https://github.com/tomas-abrahamsson/gpb", tag: "4.0.2"},
      {:ranch, git: "https://github.com/ninenines/ranch", tag: "1.3.2"},
      {:abci_server, github: "KrzysiekJ/abci_server", branch: "master"}
    ]
  end
end

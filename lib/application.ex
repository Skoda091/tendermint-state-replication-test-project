defmodule TendermintStateReplicationTestProject.Application do
  use Application
  alias TendermintStateReplicationTestProject.Transaction

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Transaction, []),
      worker(:abci_server_sup, [{Transaction, 46658}])
    ]

    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end
end
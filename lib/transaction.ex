defmodule TendermintStateReplicationTestProject.Transaction do
  use GenServer
  # use :abci_app
  @behaviour :abci_app

  ## Client API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def create(transaction, options) do
    GenServer.cast(__MODULE__, {:send_transaction, options})
  end

  ## Server Callbacks

  def init(:ok) do
    IO.puts "#init: "
    {:ok, %{}}
  end

  def handle_call({:send_transaction, options}, _, _) do
    IO.puts "#call: "

    # {:reply, "", ""}
    {:RequestCheckTx, "", ""}
    {:RequestDeliverTx, "", ""}
  end

  def handle_cast({:send_transaction, options}, _, _) do
    IO.puts "#cast: "
    process_request({:RequestDeliverTx})
    {:noreply, ""}
  end

  def handle_info(_msg, names) do
    IO.puts "#info: "
    {:noreply, ""}
  end

  def handle_request(request) do
    IO.puts "#request: "
    process_request(request)
  end

  def terminate(_, _) do
    IO.puts "#terminate: "
    :ok
  end

  def change_code(_, _, _) do
    IO.puts "#change_code: "
    {:ok, ""}
  end

  # Internal functions

  defp process_request({:RequestInfo, version}) do
    IO.puts "RequestInfo:"
    IO.inspect version, label: "VERSION"
    {:ResponseInfo, :undefined, "0.1.0", 0, <<>>}
  end

  defp process_request({:RequestInitChain, validators}) do
    IO.puts "RequestInitChain:"
    IO.inspect validators, label: "VALIDATORS"
    {:ResponseInitChain, :undefined}
  end

  defp process_request({:RequestBeginBlock, hash, header, absent_validators, byzantine_validators}) do
    IO.puts "RequestBeginBlock:"
    IO.inspect hash, label: "HASH"
    IO.inspect header, label: "HEADER"
    IO.inspect absent_validators, label: "ABSENT_VALIDATORS"
    IO.inspect byzantine_validators, label: "BYZANTINE_VALIDATORS"
    {:ResponseBeginBlock, :undefined}
  end

  defp process_request({:RequestEndBlock, height}) do
    IO.puts "RequestEndBlock:"
    IO.inspect height, label: "HEIGHT"
    {:ResponseEndBlock, []}
  end

  defp process_request({:RequestCommit}) do
    IO.puts "RequestCommit:"
    {:ResponseCommit, :undefined, :undefined, :undefined}
  end

  defp process_request({:RequestCheckTx, tx}) do
    IO.puts "RequestCheckTx:"
    IO.inspect tx, label: "TX"
    # TODO: check data against nonce
    {:ResponseCheckTx, :undefined, :undefined, :undefined, :undefined, :undefined}
  end

  defp process_request({:RequestDeliverTx, tx}) do
    IO.puts "RequestDeliverTx:"
    IO.inspect tx, label: "TX"
    {:ResponseDeliverTx, :undefined, :undefined, :undefined, []}
  end

  defp process_request({:RequestQuery, data, path, height, prove}) do
    IO.puts "RequestQuery:"
    IO.inspect data, label: "DATA"
    IO.inspect path, label: "PATH"
    IO.inspect height, label: "HEIGHT"
    IO.inspect prove, label: "PROVE"
    {:ResponseQuery, :undefined, :undefined, :undefined, :undefined, :undefined, :undefined, :undefined}
  end
end


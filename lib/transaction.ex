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
    # IO.puts "#init: "
    {:ok, %{}}
  end

  def handle_call(request, from, state) do
    IO.inspect state, label: "#received_state"
    state_values = with [_| _] <- state do
      state
    else
      [state_values] -> [state_values]
       _ -> []
    end
    # IO.puts "#call: "
    {response, new_state_values} = process_request(request, state_values)
    # IO.inspect new_state_values, label: "#new_state"
    {:reply, response, new_state_values}
  end

  def handle_cast({:send_transaction, options}, _, _) do
    # IO.puts "#cast: "
    {:noreply, ""}
  end

  def handle_info(_msg, names) do
    # IO.puts "#info: "
    {:noreply, ""}
  end

  def handle_request(request) do
    # IO.puts "#request: "
    GenServer.call(__MODULE__, request)
  end

  def terminate(_, _) do
    # IO.puts "#terminate: "
    :ok
  end

  def change_code(_, _, _) do
    # IO.puts "#change_code: "
    {:ok, ""}
  end

  # Internal functions

  defp process_request({:RequestInfo, version}, state) do
    # IO.puts "RequestInfo:"
    # IO.inspect version, label: "VERSION"
    {{:ResponseInfo, :undefined, "0.1.0", 0, <<>>}, state}
  end

  defp process_request({:RequestInitChain, validators}, state) do
    # IO.puts "RequestInitChain:"
    # IO.inspect validators, label: "VALIDATORS"
    {{:ResponseInitChain, :undefined}, state}
  end

  defp process_request({:RequestBeginBlock, hash, header, absent_validators, byzantine_validators}, state) do
    # IO.puts "RequestBeginBlock:"
    # IO.inspect hash, label: "HASH"
    # IO.inspect header, label: "HEADER"
    # IO.inspect absent_validators, label: "ABSENT_VALIDATORS"
    # IO.inspect byzantine_validators, label: "BYZANTINE_VALIDATORS"
    {{:ResponseBeginBlock, :undefined}, state}
  end

  defp process_request({:RequestEndBlock, height}, state) do
    # IO.puts "RequestEndBlock:"
    # IO.inspect height, label: "HEIGHT"
    {{:ResponseEndBlock, []}, state}
  end

  defp process_request({:RequestCommit}, state) do
    # IO.puts "RequestCommit:"
    {{:ResponseCommit, :undefined, :undefined, :undefined}, state}
  end

  defp process_request({:RequestCheckTx, tx}, state) do
    IO.puts "RequestCheckTx:"
    IO.inspect tx, label: "TX"
    # TODO: check data against nonce
    {{:ResponseCheckTx, :undefined, tx, :undefined, :undefined, :undefined}, state}
  end

  defp process_request({:RequestDeliverTx, tx}, state) do
    # IO.puts "RequestDeliverTx:"
    # IO.inspect tx, label: "TX"
    tx = parse_tx(tx)
    {{:ResponseDeliverTx, :undefined, :undefined, :undefined, []}, Keyword.merge(state, tx)}
  end

  defp process_request({:RequestQuery, data, path, height, prove}, state) do
    IO.puts "RequestQuery:"
    IO.inspect data, label: "DATA"
    IO.inspect path, label: "PATH"
    IO.inspect height, label: "HEIGHT"
    IO.inspect prove, label: "PROVE"
    {{:ResponseQuery, :undefined, :undefined, :undefined, data, :undefined, :undefined, :undefined}, state}
  end

  defp parse_tx(tx) do
    tx
    |> String.split(":")
    |> Enum.map(fn(x) -> String.split(x, "=") end)
    |> Enum.map(fn(x) ->
      with [key, value] <- x do
        {String.to_atom(key), value}
      else
        [value] -> {:undefined, value}
      end
    end)
  end
end


defmodule TendermintStateReplicationTestProject.Transaction do
  use GenServer
  # use :abci_app
  @behaviour :abci_app

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ## Server Callbacks

  def init(:ok) do
    IO.puts "#init: "
    {:ok, %{}}
  end

  def handle_call(_msg, _from, names) do
    IO.puts "#call: "

    {:reply, "", ""}
  end

  def handle_cast(_msg, names) do
    IO.puts "#cast: "
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

  defp process_request({:RequestInfo}) do
    IO.puts "RequestInfo:"
    {:ResponseInfo, :undefined, "0.1.0", 0, <<>>}
  end

  defp process_request({:RequestInitChain, data}) do
    IO.puts "RequestInitChain:"
    IO.inspect data
    {:ResponseInitChain, :undefined}
  end

  defp process_request({:RequestBeginBlock, data, data1}) do
    IO.puts "RequestBeginBlock:"
    IO.inspect data
    IO.inspect data1
    {:ResponseBeginBlock, :undefined}
  end

  defp process_request({:RequestEndBlock, data}) do
    IO.puts "RequestEndBlock:"
    IO.inspect data
    {:ResponseEndBlock, []}
  end

  defp process_request({:RequestCommit}) do
    IO.puts "RequestCommit:"
    {:ResponseCommit, :OK, :undefined, :undefined}
  end
end
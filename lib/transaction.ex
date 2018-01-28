defmodule TendermintStateReplicationTestProject.Transaction do
  use GenServer
  @behaviour :abci_app

  @whitelisted_participants ~w(a b c d)

  ## Client API

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(request, _from, state) do
    state_values =
      with [_ | _] <- state do
        state
      else
        [state_values] -> [state_values]
        _ -> []
      end

    {response, new_state_values} = process_request(request, state_values)
    {:reply, response, new_state_values}
  end

  def handle_cast({:send_transaction, _options}, _, _) do
    {:noreply, ""}
  end

  def handle_info(_msg, _names) do
    {:noreply, ""}
  end

  def handle_request(request) do
    GenServer.call(__MODULE__, request)
  end

  def terminate(_, _) do
    :ok
  end

  def change_code(_, _, _) do
    {:ok, ""}
  end

  # Internal functions

  defp process_request({:RequestInfo, version}, state) do
    {{:ResponseInfo, :undefined, version, 0, <<>>}, state}
  end

  defp process_request({:RequestInitChain, _validators}, state) do
    # INFO: init state paints that participant "a" has the ball
    state =
      if Keyword.has_key?(state, :participant_who_has_the_ball) do
        state
      else
        Keyword.merge(state, participant_who_has_the_ball: "a")
      end

    state =
      if Keyword.has_key?(state, :root_hash) do
        state
      else
        mt = MerkleTree.new(@whitelisted_participants)
        Keyword.merge(state, root_hash: mt.root)
      end

    {{:ResponseInitChain, :undefined}, state}
  end

  defp process_request(
         {:RequestBeginBlock, _hash, _header, _absent_validators, _byzantine_validators},
         state
       ) do
    {{:ResponseBeginBlock, :undefined}, state}
  end

  defp process_request({:RequestEndBlock, _height}, state) do
    {{:ResponseEndBlock, []}, state}
  end

  defp process_request({:RequestCommit}, state) do
    {{:ResponseCommit, :undefined, :undefined, :undefined}, state}
  end

  defp process_request({:RequestCheckTx, tx}, state) do
    data =
      with tx <- parse_tx(tx),
           {:ok, from, to, mt_node} <- get_params(tx, state),
           :ok <- check_ball_owner(from, state),
           mt_tree <- create_merkle_tree(mt_node),
           {:ok, to_index} <- get_index(to),
           %MerkleTree.Proof{hashes: _proof} = mt_proof <-
             MerkleTree.Proof.prove(mt_tree, to_index),
           true <- MerkleTree.Proof.proven?({to, to_index}, mt_node.value, mt_proof) do
        %{code: 0, log: :undefined}
      else
        {:error, message} -> %{code: 1, log: message}
        false -> %{code: 1, log: "Transaction failed because of merkle proof is invalid"}
      end

    {{:ResponseCheckTx, data.code, :undefined, data.log, :undefined, :undefined}, state}
  end

  defp process_request({:RequestDeliverTx, tx}, state) do
    data =
      with tx <- parse_tx(tx),
           {:ok, _from, to, _mt_node} <- get_params(tx, state),
           {:ok, new_state} <- update_state(state, to) do
        %{code: 0, log: :undefined, state: new_state}
      else
        {:error, message} -> %{code: 1, log: message, state: state}
      end

    {{:ResponseDeliverTx, data.code, :undefined, data.log, []}, data.state}
  end

  defp process_request({:RequestQuery, data, _path, _height, _prove}, state) do
    data =
      with {:ok, value} <- get_from_state(data, state) do
        %{code: 0, log: :undefined, value: value, key: data}
      else
        {:error, message} -> %{code: 1, log: message, value: "", key: data}
      end

    {{:ResponseQuery, data.code, :undefined, data.key, data.value, :undefined, :undefined,
      data.log}, state}
  end

  defp parse_tx(tx) do
    tx
    |> String.split(":")
    |> Enum.map(fn x -> String.split(x, "=") end)
    |> Enum.map(fn x ->
      with [key, value] <- x do
        {String.to_atom(key), value}
      else
        [value] -> {:undefined, value}
      end
    end)
  end

  defp get_params(tx, state) do
    with {:ok, mt_node} <- Keyword.fetch(state, :root_hash),
         {:ok, from} <- Keyword.fetch(tx, :from),
         {:ok, to} <- Keyword.fetch(tx, :to) do
      {:ok, from, to, mt_node}
    else
      :error -> {:error, "Wrong parameters."}
    end
  end

  defp get_index(key) do
    key = String.to_atom(key)
    list = Enum.with_index(@whitelisted_participants)
    keywordlist = for {key, value} <- list, do: {String.to_atom(key), value}

    case Keyword.fetch(keywordlist, key) do
      {:ok, index} -> {:ok, index}
      :error -> {:error, "Unknown destination participant."}
    end
  end

  defp create_merkle_tree(node) do
    %MerkleTree{
      root: node,
      hash_function: &MerkleTree.Crypto.sha256/1,
      blocks: @whitelisted_participants
    }
  end

  defp check_ball_owner(from, state) do
    with {:ok, owner} <- Keyword.fetch(state, :participant_who_has_the_ball),
         true <- from == owner do
      :ok
    else
      :error ->
        {:error, "No information about the ball owner."}

      false ->
        {:error, "Current ball owner is incorrect, #{from} participant doesn't have the ball."}
    end
  end

  defp get_from_state(data, state) do
    with key <- String.to_atom(data),
         {:ok, value} <- Keyword.fetch(state, key) do
      {:ok, value}
    else
      :error -> {:error, "No data in state about #{data}."}
    end
  end

  defp update_state(current_state, ball_destination) do
    with {:ok, _owner} <- Keyword.fetch(current_state, :participant_who_has_the_ball),
         state <- Keyword.put(current_state, :participant_who_has_the_ball, ball_destination) do
      {:ok, state}
    else
      :error -> {:error, "No information about the ball owner."}
    end
  end
end

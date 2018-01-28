defmodule TendermintStateReplicationTestProject.BallService do
  def pass_ball(from, to) do
    params = "from=#{from}:to=#{to}"
    {:ok, response} = HTTPoison.get(
      ~s(http://localhost:46657/broadcast_tx_commit?tx="#{params}"),
      [],
      ssl: [{:versions, [:"tlsv1.2"]}]
    )
    data =
      response.body
      |> Poison.decode!()
      |> Map.get("result")

    if data == nil do
      response.body
      |> Poison.decode!()
      |> Map.get("error")
    else
      data
    end
  end

  def check_ball_owner() do
    {:ok, response} = HTTPoison.get(
      ~s(http://localhost:46657/abci_query?data="participant_who_has_the_ball"),
      [],
      ssl: [{:versions, [:"tlsv1.2"]}]
    )
    decode_response(response)
  end

  def decode_response(response) do
    response =
    response.body
    |> Poison.decode!()
    |> Map.get("result")
    |> Map.get("response")
  {:ok, decoded_key} =
    response
    |> Map.get("key")
    |> Base.decode16()
  {:ok, decoded_value} =
    response
    |> Map.get("value")
    |> Base.decode16()
  decoded_response =
    response
    |> Map.put("decoded_key", decoded_key)
  decoded_response
    |> Map.put("decoded_value", decoded_value)
  end
end
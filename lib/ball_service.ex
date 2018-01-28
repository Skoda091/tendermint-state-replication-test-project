defmodule TendermintStateReplicationTestProject.BallService do
  def pass_ball(from, to) do
    params = "from=#{from}:to=#{to}"
    HTTPoison.get(~s(http://localhost:46657/broadcast_tx_commit?tx="#{params}"), [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
  end

  def check_ball_owner() do
    HTTPoison.get(~s(http://localhost:46657/abci_query?data="participant_who_has_the_ball"), [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
  end
end
defmodule TendermintStateReplicationTestProject.Request do
  # INFO: expexted parmas int form, e.g. "key1=value1:key2=value2"
  def send_tx(param \\ "name=satoshi") do
    HTTPoison.get(~s(http://localhost:46657/broadcast_tx_commit?tx="#{param}"), [], [ ssl: [{:versions, [:'tlsv1.2']}] ])
  end
end
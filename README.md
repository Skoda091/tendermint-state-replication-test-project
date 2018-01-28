# Tendermint state replication test project

An Elixir application which uses tendermint for replicating state in blockchain.

## Goal

Simulation of passing a ball between defined participants as a blckochain transaction.

Assumptions:
* There is array of whitelisted participants `["a", "b", "c", "d"]`.
* The initial state of the app is that participant `"a"` is holding a ball. This information is stored in state ander the key `:participant_who_has_the_ball`.
* `checkTX` block is responsible for validating transaction against merkle proof and current state of the blockchain.
* `deliverTX` is responsible for updateing the state of blockchain.
* `tx` parameter for tendermint passing a ball transaction is send as value of two fields `tx="from=a:to=b"` which is later on parsed in the app.
## Instalation

* Install tendermint ([instructions](http://tendermint.readthedocs.io/projects/tools/en/master/install.html))
* Install elixir (recommend [asdf](https://github.com/asdf-vm/asdf))
* Clone this repository
```bash
git clone git@github.com:Skoda091/tendermint-state-replication-test-project.git
```

## Usage

* Run tendermint
  ```bash
  tendermint init
  ```
  ```bash
  tendermint node
  ```

* Run elixir app
  ```bash
  mix deps.get
  ```
  ```bash
  iex -S mix
  ```
* To pass the ball to a whitelisted participant run from interactive Elixir (IEx)
  ```elixir
  iex(1)> TendermintStateReplicationTestProject.BallService.pass_ball("a", "b")
  ```

  Where first argument is a current owner of the ball and the second argument is destination participant.
  This fuction will create HTTP request to tendermint.
  ```bash
  http://localhost:46657/broadcast_tx_commit?tx="from=a:to=b"
  ```
  Expected result of this function.
  ```elixir
  {:ok, %HTTPoison.Response{
   body: "{\n  \"jsonrpc\": \"2.0\",\n  \"id\": \"\",\n  \"result\": {\n    \"check_tx\": {\n      \"code\": 0,\n      \"data\": \"\",\n      \"log\": \"\",\n      \"gas\": \"0\",\n      \"fee\": \"0\"\n    },\n    \"deliver_tx\": {\n      \"code\": 0,\n      \"data\": \"\",\n      \"log\": \"\",\n      \"tags\": []\n    },\n    \"hash\": \"492AC2718137712A2733177090971DB28B71F23E\",\n    \"height\": 161\n  }\n}",
   headers: [
     {"Access-Control-Allow-Credentials", "true"},
     {"Access-Control-Allow-Origin", ""},
     {"Access-Control-Expose-Headers", "X-Server-Time"},
     {"Content-Type", "application/json"},
     {"X-Server-Time", "1517161816"},
     {"Date", "Sun, 28 Jan 2018 17:50:17 GMT"},
     {"Content-Length", "335"}
   ],
   request_url: "http://localhost:46657/broadcast_tx_commit?tx=\"from=a:to=b\"",
   status_code: 200}}
  ```
* To check the current state of the ball run from iex
  ```elixir
  iex(2)> TendermintStateReplicationTestProject.BallService.check_ball_owner()
  ```
  Expected result of this function.
  ```elixir
  {:ok, %HTTPoison.Response{
   body: "{\n  \"jsonrpc\": \"2.0\",\n  \"id\": \"\",\n  \"result\": {\n    \"response\": {\n      \"code\": 0,\n      \"index\": \"0\",\n      \"key\": \"7061727469636970616E745F77686F5F6861735F7468655F62616C6C\",\n      \"value\": \"62\",\n      \"proof\": \"\",\n      \"height\": \"0\",\n      \"log\": \"\"\n    }\n  }\n}",
   headers: [
     {"Access-Control-Allow-Credentials", "true"},
     {"Access-Control-Allow-Origin", ""},
     {"Access-Control-Expose-Headers", "X-Server-Time"},
     {"Content-Type", "application/json"},
     {"X-Server-Time", "1517161965"},
     {"Date", "Sun, 28 Jan 2018 17:52:45 GMT"},
     {"Content-Length", "264"}
   ],
   request_url: "http://localhost:46657/abci_query?data=\"participant_who_has_the_ball\"",
   status_code: 200}}
  ```
## Tech stack

* elixir [1.6.0](https://elixir-lang.org/blog/2018/01/17/elixir-v1-6-0-released/)
* tendermint [0.14.0](https://github.com/tendermint/tendermint)
* abci_server [0.3.0](https://github.com/KrzysiekJ/abci_server)
* merkle_tree [1.2.1](https://github.com/yosriady/merkle_tree)

## Todo

- [ ] Add unit tests unit and integration
- [ ] Add integration tests
- [ ] Add documentation
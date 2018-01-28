# Tendermint state replication test project

An Elixir application which uses tendermint for replicating the state in blockchain.

## Goal

Simulation of passing a ball between defined participants as a blckochain transaction.

Assumptions:
* There is an array of whitelisted participants `["a", "b", "c", "d"]`.
* The initial state of the app is that participant `"a"` is holding a ball. This information is stored in the state under the key `:participant_who_has_the_ball`.
* `checkTX` block is responsible for validating transaction against a merkle proof and the current state of the blockchain.
* `deliverTX` is responsible for updating the state of the blockchain.
* `tx` tendermint parameter for passing the ball transaction is sent as a value of two fields `tx="from=a:to=b"` which is later parsed in the app.
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
* To pass the ball to a whitelisted participant, run from interactive Elixir (IEx):
  ```elixir
  iex(1)> TendermintStateReplicationTestProject.BallService.pass_ball("a", "b")
  ```

  Where the first argument is the current owner of the ball and the second argument is the recipient.
  This fuction will create an HTTP request to tendermint.
  ```bash
  http://localhost:46657/broadcast_tx_commit?tx="from=a:to=b"
  ```
  Expected result of this function.
  ```elixir
  %{
    "check_tx" => %{
      "code" => 0,
      "data" => "",
      "fee" => "0",
      "gas" => "0",
      "log" => ""
    },
    "deliver_tx" => %{"code" => 0, "data" => "", "log" => "", "tags" => []},
    "hash" => "492AC2718137712A2733177090971DB28B71F23E",
    "height" => 4
  }
  ```
  Example of incorrect transaction result.
  ```elixir
    %{
    "check_tx" => %{
      "code" => 1,
      "data" => "",
      "fee" => "0",
      "gas" => "0",
      "log" => "Current ball owner is incorrect, a participant doesn't have the ball."
    },
    "deliver_tx" => %{"code" => 0, "data" => "", "log" => "", "tags" => []},
    "hash" => "492AC2718137712A2733177090971DB28B71F23E",
    "height" => 0
    }
  ```
* To check the current state of the ball run from iex:
  ```elixir
  iex(2)> TendermintStateReplicationTestProject.BallService.check_ball_owner()
  ```
  Expected result of this function.
  ```elixir
  %{
    "code" => 0,
    "decoded_key" => "participant_who_has_the_ball",
    "decoded_value" => "b",
    "height" => "0",
    "index" => "0",
    "key" => "7061727469636970616E745F77686F5F6861735F7468655F62616C6C",
    "log" => "",
    "proof" => "",
    "value" => "62"
  }
  ```
  Result extended with keys `decoded_key` and `decoded_value` only for the purpose of convinience while testing.
## Tech stack

* elixir [1.6.0](https://elixir-lang.org/blog/2018/01/17/elixir-v1-6-0-released/)
* tendermint [0.14.0](https://github.com/tendermint/tendermint)
* abci_server [0.3.0](https://github.com/KrzysiekJ/abci_server)
* merkle_tree [1.2.1](https://github.com/yosriady/merkle_tree)

## Todo

- [ ] Add unit tests unit and integration
- [ ] Add integration tests
- [ ] Add documentation
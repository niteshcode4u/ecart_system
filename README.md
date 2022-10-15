# EcartSystem

An OTP application for adding items to the cart by scanning one by one and providing calculated price after applying all the offers.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecart_system` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecart_system, "~> 0.1.0"}
  ]
end
```

## How it works:

  Step I: Need to start the transaction

  ```elixir
    iex> EcartSupervisor.start_transaction()
    {:ok, "Trasaction started"}
  ```

  Step II: Scan product one-by-one

  ```elixir
    iex> EcartManager.scan_product("VOUCHER")
    :ok

    iex> EcartManager.scan_product("MUG")
    :ok

    iex> EcartManager.scan_product("TSHIRT")
    :ok
  ```

  Step III: Calculate price for scanned products
  
  ```elixir
    iex> EcartManager.calculate_total()
    "32.5€"
  ```

  Step IV: Complete the transaction to intiate a new Ecart

  ```elixir
    iex> EcartSupervisor.complete_transaction()
    {:ok, "Transaction completed"}
  ```

## Test coverage

<img width="692" alt="Screenshot 2022-10-16 at 1 14 05 AM" src="https://user-images.githubusercontent.com/20892499/196005491-62aee53e-0947-4f22-9eff-fd105308f50c.png">

## Limitations: 
1. We can define proper structure for product in case we have to display the products
2. We can start multiple trasactions based on users as currently we have a limitation with one running transaction

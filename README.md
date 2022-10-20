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

## How the application works:
  After forking and cloning the repository from `https://github.com/niteshcode4u/ecart_system.git`
  1. install dependencies: ```mix deps.get```
  2. Then compile the project: ```mix compile```
  3. Then you can start the interactive Elixir shell: ```iex -S mix```
  4. After performing above please follow below steps into iex console
  
  Case I: Scan product one-by-one

  Step I:
  ```elixir
    iex> EcartSystem.scan_product("VOUCHER")
    true

    iex> EcartSystem.scan_product("TSHIRT")
    true

    iex> EcartSystem.scan_product("MUG")
    true
  ```

  Step II:
  ```elixir
    iex> EcartSystem.add_total()
    "34€"
  ```

  Case II: Scan all products at once
  
  ```elixir
    iex> products = ["VOUCHER", "TSHIRT", "VOUCHER", "VOUCHER", "MUG", "TSHIRT", "TSHIRT"]
    iex> EcartSystem.scan_products(products)
    "74.5€"

    iex> products = ["TSHIRT", "TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT"]
    iex> EcartSystem.scan_products("TSHIRT")
    "81.00€"
  ```

## How to Add/ Update/ Delete products into table:
  We are keeping 3 default products `voucher: 5.00, tshirt: 20.00, mug: 7.50` with prices
  However admin can add, modify, and delete the products based on requirements.

  Please follow below steps to perform the job.

  I: Fetch prices of available products

  ```elixir
    iex> EcartSystem.Product.fetch_prices()
    %{mug: 7.5, pen: 2.0, tshirt: 20.0, voucher: 5.0}
  ```

  II: Add the products
  
  ```elixir
    iex>  EcartSystem.Product.insert_or_update(:pen, 2.0)
    true
  ```

  III: Update the price of the products

  ```elixir
    iex>  EcartSystem.Product.insert_or_update(:voucher, 10.0)
    true
  ```

  IV: Remove the product from list

  ```elixir
    iex> EcartSystem.Product.delete(:voucher)
    true
  ```

  V: Reset complete data to default product along with price

  ```elixir
    iex> EcartSystem.Product.reset_data()
    true
  ```
## Test coverage

<img width="692" alt="Screenshot 2022-10-16 at 1 14 05 AM" src="https://user-images.githubusercontent.com/20892499/196005491-62aee53e-0947-4f22-9eff-fd105308f50c.png">

## Possible Areas of Enhancement: 
1. We can define proper structure for product in case we have to display the product with details
2. We can start multiple trasactions based on users as currently we have a limitation with one running transaction
3. While doing complete transaction we can set it to default empty `%{}` rather than killing child however, here I thought
  of keeping `Start` & `Complete` button for transaction.
4. We can add all possible validations at input parameters & responses

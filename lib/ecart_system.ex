defmodule EcartSystem do
  @moduledoc """
  Documentation for `EcartSystem`.
  """

  import EcartSystem.Product, only: [fetch_prices: 0]
  import EcartSystem.Cart

  @spec scan_product(String.t()) :: boolean()
  @doc """
    Scan product/ item one by one and return true/ false in response

    ## Examples

      iex> EcartSystem.scan_product("VOUCHER")
      true

      iex> EcartSystem.scan_product("TSHIRT")
      true

      iex> EcartSystem.scan_product("MUG")
      true

      iex> EcartSystem.scan_product("PEN")
      false

  """
  def scan_product(product_code) do
    stored_products = Map.keys(fetch_prices())

    product_code =
      product_code
      |> String.downcase()
      |> String.to_atom()

    if product_code in stored_products,
      do: add_product(product_code),
      else: false
  end

  @spec scan_products(String.t()) :: String.t()
  @doc """
    Scan all products/ items at once and returns total

    ## Examples

      iex> products = ["VOUCHER", "TSHIRT", "VOUCHER", "VOUCHER", "MUG", "TSHIRT", "TSHIRT"]
      iex> EcartSystem.scan_products(products)
      "74.5€"

      iex> products = ["TSHIRT", "TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT"]
      iex> EcartSystem.scan_products("TSHIRT")
      "81.00€"
  """
  def scan_products(product_codes) when is_list(product_codes) do
    stored_products = Map.keys(fetch_prices())

    price =
      product_codes
      |> Enum.reduce(%{}, fn product_code, products_qty ->
        parsed_product_code = product_code |> String.downcase() |> String.to_atom()

        if parsed_product_code in stored_products do
          Map.update(products_qty, parsed_product_code, 1, &(&1 + 1))
        else
          products_qty
        end
      end)
      |> calculate_total_amount()

    "#{price}€"
  end

  def scan_products(_product_codes), do: "0€"

  @spec add_total :: String.t()
  @doc """
  Calculate total of all scanned items from cart table
  """
  def add_total do
    "#{calculate_total_amount(cart())}€"
  end

  defp calculate_total_amount(products) do
    Enum.reduce(products, 0, fn {product, quantity}, total ->
      product_cost = pricing_rule(product, quantity, fetch_prices())
      product_cost + total
    end)
  end

  defp pricing_rule(:voucher, quantity, price), do: round(quantity / 2) * price.voucher
  defp pricing_rule(:tshirt, quantity, price) when quantity > 2, do: quantity * (price.tshirt - 1)
  defp pricing_rule(product, quantity, price), do: quantity * price[product]
end

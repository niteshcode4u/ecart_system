defmodule EcartSystem.Cart do
  @moduledoc false

  @cart "cart"
  @cart_table :"cart_#{Mix.env()}"
  @default_card %{}

  @spec set_default_cart :: boolean
  def set_default_cart do
    :ets.new(@cart_table, [:set, :public, :named_table])

    :ets.insert_new(@cart_table, {@cart, @default_card})
  end

  @spec add_product(any) :: true
  @doc """
    Add product quantity to the cart.
  """
  def add_product(product_code) do
    [{"cart", cart}] = :ets.lookup(@cart_table, @cart)

    :ets.insert(@cart_table, {@cart, Map.update(cart, product_code, 1, &(&1 + 1))})
  end

  @spec cart :: map()
  @doc """
    Return cached map
  """
  def cart do
    [{"cart", cart}] = :ets.lookup(@cart_table, @cart)

    cart
  end

  @spec reset_data :: true
  @doc """
    Delete all cached value and set it to default value into ETS products table.
  """
  def reset_data do
    :ets.insert(@cart_table, {@cart, @default_card})
  end
end

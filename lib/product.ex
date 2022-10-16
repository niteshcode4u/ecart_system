defmodule EcartSystem.Product do
  @moduledoc """
  A simple ETS based cache for expensive function calls.
  """

  @product_table :"products_#{Mix.env}"
  @product "product"
  @default_products %{voucher: 5.00, tshirt: 20.00, mug: 7.50}

  @spec set_default_products :: boolean
  def set_default_products do
    :ets.new(@product_table, [:set, :public, :named_table])

    :ets.insert_new(@product_table, {@product, @default_products})
  end

  @spec insert_or_update(atom(), number()) :: boolean
  @doc """
    Insert product data based on product code as key for caching into ETS.
  """
  def insert_or_update(product_code, price) do
    [{"product", product_data}] = :ets.lookup(@product_table, @product)

    :ets.insert(@product_table, {@product, Map.put(product_data, product_code, price)})
  end

  @spec fetch_prices :: map()
  @doc """
    Retrieve a cached value or apply the given function caching and returning the result.
  """
  def fetch_prices do
    [{"product", product}] = :ets.lookup(@product_table, @product)

    product
  end


  @spec delete(atom()) :: boolean
  @doc """
    Delete one product from cached value and return true.
  """
  def delete(product_code) do
    [{"product", product_data}] = :ets.lookup(@product_table, @product)

    :ets.insert(@product_table, {@product, Map.delete(product_data, product_code)})
  end

  @spec reset_data :: true
  @doc """
    Delete all cached value and set it to default value into ETS products table.
  """
  def reset_data do
    :ets.insert(@product_table, {@product, @default_products})
  end
end

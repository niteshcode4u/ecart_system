defmodule EcartSystem.Managers.EcartManager do
  @moduledoc """
  To handle the state of shopping cart
  """

  use GenServer, restart: :transient

  import EcartSystem.Product, only: [fetch_prices: 0]

  # Client APIs #############################################################

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_ecart_session :: {:ok, map()}
  def get_ecart_session do
    GenServer.call(__MODULE__, :get_ecart_session)
  end

  @spec scan_product(String.t()) :: :ok
  def scan_product(product_code) do
    GenServer.cast(__MODULE__, {:scan_product, product_code})
  end

  @spec calculate_total :: String.t()
  def calculate_total do
    GenServer.call(__MODULE__, :calculate_total)
  end

  # Call Handlers #############################################################

  @impl GenServer
  def init(_opts) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call(:get_ecart_session, _from, state) do
    products = Map.keys(fetch_prices())

    state =
      state
      |> Enum.filter(fn {product, _quantity} ->
        product in products
      end)
      |> Map.new()

    {:reply, {:ok, state}, state}
  end

  @impl GenServer
  def handle_call(:calculate_total, _from, state) do
    total_amount = calculate_total_amount(state)
    {:reply, "#{total_amount}€", state}
  end

  @impl GenServer
  def handle_cast({:scan_product, product_code}, state) do
    product_code = product_code |> String.downcase() |> String.to_atom()

    if product_code in Map.keys(fetch_prices()) do
      {:noreply, Map.put(state, product_code, (state[product_code] || 0) + 1)}
    else
      {:noreply, state}
    end
  end

  # Private functions #############################################################

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

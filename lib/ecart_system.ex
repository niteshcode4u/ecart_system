defmodule EcartSystem do
  @moduledoc """
  Documentation for `EcartSystem`.
  """

  alias EcartSystem.EcartSupervisor
  alias EcartSystem.Managers.EcartManager

  @spec start_transaction :: {:error, String.t()} | {:ok, String.t()}
  @doc """
    Starts the transaction to add product into the cart or throw error if already exist

    ## Examples

      iex> EcartSupervisor.start_transaction()
      {:ok, "Trasaction started"}

      iex> EcartSupervisor.start_transaction()
      {:error, "Already exists. Please complete the transaction first."}

  """
  defdelegate start_transaction, to: EcartSupervisor

  @spec complete_transaction :: {:ok, String.t()} | {:error, String.t()}
  @doc """
    Completed the transaction for the available items into cart

    ## Examples

      iex> EcartSupervisor.complete_transaction()
      {:ok, "Transaction completed"}

      iex> EcartSupervisor.complete_transaction()
      {:error, "No child found"}

  """
  defdelegate complete_transaction, to: EcartSupervisor

  @spec scan_product(String.t()) :: :ok
  @doc """
    Scan product/ item one by one and return :ok in response

    ## Examples

      iex> EcartManager.scan_product("VOUCHER")
      :ok

      iex> EcartManager.scan_product("TSHIRT")
      :ok

      iex> EcartManager.scan_product("MUG")
      :ok

  """
  defdelegate scan_product(product_code), to: EcartManager

  @spec calculate_total :: String.t()
  @doc """
    Calculate total price by adding offers and return total amount in EUR

    Please note we are considering all amounts in currency EUR
    ## Examples

      iex> EcartManager.calculate_total()
      "0€"

  """
  defdelegate calculate_total, to: EcartManager
end

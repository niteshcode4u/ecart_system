defmodule EcartSystem.EcartSupervisor do
  @moduledoc false

  use GenServer

  @supervisor __MODULE__

  alias EcartSystem.Managers.EcartManager

  @doc """
  Starts the supervisor.
  """
  def start_link(opts) do
    DynamicSupervisor.start_link(@supervisor, opts, name: @supervisor)
  end

  @impl GenServer
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec start_transaction :: {:error, String.t()} | {:ok, String.t()}
  @doc """
  Ensures to initiate cart for given products
  """
  def start_transaction do
    case DynamicSupervisor.start_child(@supervisor, {EcartManager, []}) do
      {:ok, _pid} ->
        {:ok, "Trasaction started"}

      {:error, {:already_started, _pid}} ->
        {:error, "Already exist. Please complete the transaction first."}
    end
  end

  @spec complete_transaction :: {:error | :ok | {:error, :not_found}, String.t()}
  @doc """
  Complete the transaction for running cart items
  """
  def complete_transaction do
    case GenServer.whereis(EcartManager) do
      nil -> {:error, "No running transaction"}
      pid -> {DynamicSupervisor.terminate_child(@supervisor, pid), "Transaction completed"}
    end
  end
end

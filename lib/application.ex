defmodule EcartSystem.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    EcartSystem.Product.set_default_products()
    EcartSystem.Cart.set_default_cart()

    opts = [strategy: :one_for_one, name: EcartSystem.Supervisor]
    Supervisor.start_link([], opts)
  end
end

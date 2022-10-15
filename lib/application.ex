defmodule EcartSystem.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      EcartSystem.EcartSupervisor
    ]

    EcartSystem.Product.set_default_products()

    opts = [strategy: :one_for_one, name: EcartSystem.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

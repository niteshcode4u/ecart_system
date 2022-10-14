defmodule EcartSystemTest do
  use ExUnit.Case
  doctest EcartSystem

  test "greets the world" do
    assert EcartSystem.hello() == :world
  end
end

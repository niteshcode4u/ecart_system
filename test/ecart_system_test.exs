defmodule EcartSystemTest do
  use ExUnit.Case, async: false

  alias EcartSystem.Cart

  setup [:clear_on_exit]

  describe "EcartSystem.scan_product/1" do
    test "Returns true when product is scanned" do
      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("MUG") == true
      assert EcartSystem.scan_product("TSHIRT") == true

      assert Cart.cart() == %{voucher: 2, mug: 1, tshirt: 1}
    end

    test "Returns false when product is scanned but not listed" do
      assert EcartSystem.scan_product("VOUCHER2") == false
      assert EcartSystem.scan_product("MUG2") == false
      assert EcartSystem.scan_product("TSHIRT2") == false

      assert Cart.cart() == %{}
    end

    test "Dynamic product insertion shouldn't effect scanning of product" do
      EcartSystem.Product.insert_or_update(:pen, 15.00)

      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("PEN") == true

      assert Cart.cart() == %{voucher: 2, pen: 1}
    end

    test "Dynamic product deletion shouldn't effect scanning of product" do
      EcartSystem.Product.delete(:voucher)

      assert EcartSystem.scan_product("VOUCHER") == false
      assert EcartSystem.scan_product("MUG") == true
      assert EcartSystem.scan_product("MUG") == true
      assert EcartSystem.scan_product("TSHIRT") == true

      assert Cart.cart() == %{mug: 2, tshirt: 1}
    end

    test "Dynamic product deletion after the scan shoun't break" do
      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("MUG") == true
      assert EcartSystem.scan_product("MUG") == true

      EcartSystem.Product.delete(:voucher)

      assert EcartSystem.scan_product("TSHIRT") == true

      assert Cart.cart() == %{mug: 2, tshirt: 1, voucher: 1}
    end
  end

  describe "EcartSystem.scan_products/1" do
    test "Returns total after calculation with offers" do
      # setup
      products = ["VOUCHER", "TSHIRT", "VOUCHER", "VOUCHER", "MUG", "TSHIRT", "TSHIRT"]
      assert EcartSystem.scan_products(products) == "74.5€"

      products = ["TSHIRT", "TSHIRT", "TSHIRT", "VOUCHER", "TSHIRT"]
      assert EcartSystem.scan_products(products) == "81.0€"
    end

    test "Return 0€ when no products in cart" do
      # setup
      products = []
      assert EcartSystem.scan_products(products) == "0€"
    end

    test "Return 0€ when no stored products are scanned" do
      # setup
      products = ["PEN", "SHOES"]
      assert EcartSystem.scan_products(products) == "0€"
    end
  end

  describe "EcartSystem.add_total/0" do
    test "Return 0 in case no item scanned" do
      assert EcartSystem.add_total() == "0€"
    end

    test "Gives total amount of scanned products" do
      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("TSHIRT") == true
      assert EcartSystem.scan_product("MUG") == true

      assert EcartSystem.add_total() == "32.5€"
    end

    test "pricing rules applied properly for the discounted products" do
      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("TSHIRT") == true
      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("VOUCHER") == true
      assert EcartSystem.scan_product("MUG") == true
      assert EcartSystem.scan_product("TSHIRT") == true
      assert EcartSystem.scan_product("TSHIRT") == true

      assert EcartSystem.add_total() == "74.5€"
    end
  end

  defp clear_on_exit(_context) do
    EcartSystem.Product.reset_data()
    EcartSystem.Cart.reset_data()

    :ok
  end
end

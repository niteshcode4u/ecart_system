defmodule EcartSystemTest do
  use ExUnit.Case, async: false

  alias EcartSystem.Managers.EcartManager

  setup [:clear_children_on_exit]

  describe "EcartSystem.start_transaction/0" do
    test "Successfully starts the transaction" do
      assert EcartSystem.start_transaction() == {:ok, "Transaction started"}
    end

    test "Error when already transaction is running" do
      EcartSystem.start_transaction()

      assert EcartSystem.start_transaction() ==
               {:error, "Already exist. Please complete the transaction first."}
    end
  end

  describe "EcartSystem.complete_transaction/0" do
    test "Successfully complete the running transaction" do
      EcartSystem.start_transaction()
      assert EcartSystem.complete_transaction() == {:ok, "Transaction completed"}
    end

    test "Error when already transaction is running" do
      assert EcartSystem.complete_transaction() == {:error, "No running transaction"}
    end
  end

  describe "EcartSystem.scan_product/1" do
    test "Returns ok when product is scanned" do
      EcartSystem.start_transaction()

      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("MUG") == :ok
      assert EcartSystem.scan_product("TSHIRT") == :ok
      assert EcartSystem.scan_product("PEN") == :ok

      assert EcartManager.get_ecart_session() == {:ok, %{voucher: 2, mug: 1, tshirt: 1}}
    end

    test "Dynamic product insertion shouldn't effect scanning of product" do
      EcartSystem.start_transaction()
      EcartSystem.Product.insert_or_update(:pen, 15.00)

      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("PEN") == :ok

      assert EcartManager.get_ecart_session() == {:ok, %{voucher: 2, pen: 1}}
    end

    test "Dynamic product deletion shouldn't effect scanning of product" do
      EcartSystem.start_transaction()
      EcartSystem.Product.delete(:voucher)

      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("MUG") == :ok
      assert EcartSystem.scan_product("MUG") == :ok
      assert EcartSystem.scan_product("TSHIRT") == :ok

      assert EcartManager.get_ecart_session() == {:ok, %{mug: 2, tshirt: 1}}
    end

    test "Dynamic product deletion after the scan shoun't break" do
      EcartSystem.start_transaction()

      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("MUG") == :ok
      assert EcartSystem.scan_product("MUG") == :ok

      EcartSystem.Product.delete(:voucher)

      assert EcartSystem.scan_product("TSHIRT") == :ok

      assert EcartManager.get_ecart_session() == {:ok, %{mug: 2, tshirt: 1}}
    end
  end

  describe "EcartSystem.calculate_total/0" do
    test "Return 0 in case no item scanned" do
      EcartSystem.start_transaction()

      assert EcartSystem.calculate_total() == "0€"
    end

    test "Gives total amount of scanned products" do
      EcartSystem.start_transaction()

      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("TSHIRT") == :ok
      assert EcartSystem.scan_product("MUG") == :ok

      assert EcartSystem.calculate_total() == "32.5€"
    end

    test "pricing rules applied properly for the discounted products" do
      EcartSystem.start_transaction()

      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("TSHIRT") == :ok
      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("VOUCHER") == :ok
      assert EcartSystem.scan_product("MUG") == :ok
      assert EcartSystem.scan_product("TSHIRT") == :ok
      assert EcartSystem.scan_product("TSHIRT") == :ok

      assert EcartSystem.calculate_total() == "74.5€"
    end
  end

  defp clear_children_on_exit(_context) do
    EcartSystem.EcartSupervisor.complete_transaction()
    EcartSystem.Product.reset_data()

    :ok
  end
end

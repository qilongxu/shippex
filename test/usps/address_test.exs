defmodule Shippex.USPS.AddressTest do
  use ExUnit.Case

  test "validate address" do
    name = "Earl G"
    phone = "123-456-7890"

    valid_address = Shippex.Address.address(%{
      "name" => name,
      "phone" => phone,
      "address" => "404 S Figueroa St",
      "city" => "Los Angeles",
      "state" => "CA",
      "zip" => "90071"
    })

    {:ok, candidates} = Shippex.validate_address(:usps, valid_address)
    assert length(candidates) == 1
    assert hd(candidates).name == name
    assert hd(candidates).phone == phone

    Enum.each candidates, fn(candidate) ->
      assert candidate.address == "404 S FIGUEROA ST"
      assert candidate.address_line_2 == ""
      assert candidate.city == "LOS ANGELES"
    end
  end

  test "validate address with line2" do
    name = "Earl G"
    phone = "123-456-7890"

    valid_address = Shippex.Address.address(%{
      "name" => name,
      "phone" => phone,
      "address" => "404 S Figueroa St",
      "address_line_2" => "Suite 101",
      "city" => "Los Angeles",
      "state" => "CA",
      "zip" => "90071"
    })

    assert valid_address.address_line_2 == "Suite 101"

    {:ok, candidates} = Shippex.validate_address(:usps, valid_address)
    assert length(candidates) == 1
    assert hd(candidates).name == name
    assert hd(candidates).phone == phone

    Enum.each candidates, fn(candidate) ->
      assert candidate.address == "404 S FIGUEROA ST"
      assert candidate.address_line_2 == "STE 101"
      assert candidate.city == "LOS ANGELES"
    end
  end

  test "validate invalid address" do
    invalid_address = Shippex.Address.address(%{
      "address" => "9999 Wat Wat",
      "city" => "San Francisco",
      "state" => "CA",
      "zip" => "90071"
    })

    {:error, _} = Shippex.validate_address(:usps, invalid_address)
  end
end

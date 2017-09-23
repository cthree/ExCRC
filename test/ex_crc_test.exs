defmodule Utility.CRCTest do
  @moduledoc false
  use ExUnit.Case

  alias Utility.CRC

  # @tag :skip
  test "crc16ccitt/1 computes the CRC of an empty string as 0xFFFF" do
    assert CRC.crc16("") == 0xffff
  end

  # @tag :skip
  test "crc16ccitt/1 computes the CRC of a space as 0xC592" do
    assert CRC.crc16(" ") == 0xc592
  end

  # @tag :skip
  test "crc16ccitt/1 computes the CRC of '123456789' as 0x29B1" do
    assert CRC.crc16("123456789") == 0x29b1
  end

  # @tag :skip
  test "crc16ccitt/1 computes the CRC of 'Lammert Bies' as 0x4A31" do
    assert CRC.crc16("Lammert Bies") == 0x4a31
  end
end

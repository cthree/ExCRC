defmodule ExCRC do
  @moduledoc """
  Quickly calculate CRC checksums in a number of variants using precomputed
  lookup tables.

  These computations are implemented entirely in Elixir using recursion. There
  is a penalty for this. This library is several orders of magnatude slower
  than the equivilent written in C or other pure binary implementation. The
  advantage to using this library is that there are no extra dependencies and it
  can be used on any platform without issue. NIF based libraries require
  compilation and linking on the target platform, this one does not.

  There are several variants of CRC so it's important to know which one you
  want to use. Refer to [the CRC catalogue](http://reveng.sourceforge.net/crc-catalogue/)
  for full details. The key parameter in identifying the variant is the
  **check** value, the CRC checksum of the string `123456789`.

  Ported to Elixir from Lammert Bies' [libCRC](https://github.com/lammertb/libcrc)
  which seems to be the defacto implementation on StackExchange. Having looked
  at and tried to implement many C libs, I found most didn't adapt well to
  functional recursion.

  It took me 3 days to convert 100 or so lines of C to 7 lines of Elixir :-)

  I make no guarantees that this software works. Test it thoroughly before you
  use it in a heart/lung machine.
  """
  use Bitwise

  # poly=0x1021, start=0xffff, check=0x29b1
  @doc """
    Compute and return the CRC16/CCITT-FALSE checksum of a binary _value_.
  """
  @spec crc16ccitt(value :: binary) :: non_neg_integer
  def crc16ccitt(value) do
    import ExCRC.Tables, only: [ccitt_table: 0]
    calc_ccitt(:binary.bin_to_list(value), 0xffff, ccitt_table())
  end

  # poly=0x1021, start=0x0000, check=0x2189, refin=yes, refout=yes
  @doc """
    Compute and return the CRC16/CCITT-TRUE checksum of a binary _value_
  """
  @spec crc16kermit(value :: binary) :: non_neg_integer
  def crc16kermit(value) do
    import ExCRC.Tables, only: [kermit_table: 0]
    calc_kermit(:binary.bin_to_list(value), 0x0000, kermit_table())
  end

  # poly=0x1021, start=0x0000, check=0x31c3
  @doc """
    Compute and return the CRC16/XMODEM checksum of a binary _value_.
  """
  @spec crc16xmodem(value :: binary) :: non_neg_integer
  def crc16xmodem(value) do
    import ExCRC.Tables, only: [ccitt_table: 0]
    calc_ccitt(:binary.bin_to_list(value), 0x0000, ccitt_table())
  end

  # Calculate CRC using ccitt table
  @spec calc_ccitt([byte], non_neg_integer, table :: map) :: non_neg_integer
  defp calc_ccitt([x | rem], crc, table) do
    key = ((crc >>> 8) ^^^ x) &&& 0xff
    crc = (crc <<< 8) ^^^ Map.get(table, key)
    calc_ccitt(rem, crc &&& 0xffff, table)
  end
  defp calc_ccitt([], crc, _), do: crc

  # Calculate CRC using kermit table
  @spec calc_kermit([byte], non_neg_integer, table :: map) :: non_neg_integer
  defp calc_kermit([x | rem], crc, table) do
    key = (crc ^^^ x) &&& 0xff
    crc = (crc >>> 8) ^^^ Map.get(table, key)
    calc_kermit(rem, crc &&& 0xffff, table)
  end
  defp calc_kermit([], crc, _) do
    low_byte = (crc &&& 0xff00) >>> 8
    high_byte = (crc &&& 0x00ff) <<< 8
    low_byte ||| high_byte
  end
end

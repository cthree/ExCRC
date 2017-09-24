defmodule ExCRC.Generator do
  @moduledoc """
    Functions used to generate static tables used by this library
  """

  use Bitwise

  #
  # Provide `print_crc_table/2` with a polynomial and it will print a
  # map in Elixir syntax which can be used statically. This is used to
  # generate the tables in this file
  #
  def print_crc_table(table, width \\ 4) do
    data =
      table
      |> Enum.to_list()
      |> List.keysort(0)
      |> Enum.map(fn({k,v}) ->
        key = :io_lib.format("~2.16.0b", [k])
        value = :io_lib.format("~4.16.0b", [v])
        "0x#{key} => 0x#{value}"
      end)
      |> Enum.chunk_every(width, width, [])
      |> Enum.map(fn(row) -> Enum.join(row, ", ") end)
      |> Enum.map(fn(row) -> "  #{row}," end)
      |> Enum.join("\n")

    trimmed =
      data
      |> String.trim_trailing("\n")
      |> String.trim_trailing(",")

    IO.puts("%{\n#{trimmed}\n}")
  end

  # Build the table data, return a map
  def crc_table(polynom) do
    for i <- 0..255, into: %{} do
      crc = 0
      c = i <<< 8
      {i, crc_entry(c, crc, 0, polynom) &&& 0xffff}
    end
  end

  # Compute a entry
  defp crc_entry(_, crc, 8, _), do: crc
  defp crc_entry(c, crc, bc, polynom) do
    case (crc ^^^ c) &&& 0x8000 do
      0 -> crc_entry(c <<< 1, crc <<< 1, bc + 1, polynom)
      _ -> crc_entry(c <<< 1, (crc <<< 1) ^^^ polynom, bc + 1, polynom)
    end
  end

  # Build the table data, return a map
  def kermit_table(polynom) do
    for i <- 0..255, into: %{} do
      crc = 0
      c = i
      {i, kermit_entry(c, crc, 0, polynom) &&& 0xffff}
    end
  end

  # Compute a entry
  defp kermit_entry(_, crc, 8, _), do: crc
  defp kermit_entry(c, crc, bc, polynom) do
    case (crc ^^^ c) &&& 1 do
      0 -> kermit_entry(c >>> 1, crc >>> 1, bc + 1, polynom)
      _ -> kermit_entry(c >>> 1, (crc >>> 1) ^^^ polynom, bc + 1, polynom)
    end
  end

end

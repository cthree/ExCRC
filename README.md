# ExCRC

Quickly calculate CRC checksums in many variants using lookup tables.

ExCRC is implemented entirely in Elixir using recursion. There
is a penalty for this: this library is much slower than if written in C or
other pure binary NIF implementation. The advantage to using this library is
that there are no extra dependencies on any platform and requires no external
tools or compilation. If you need speed, use a NIF. If you want flexibility this
library is a good choice.

There are variants of CRC so it's important to know which one you
want to use. Refer to [the CRC catalogue](http://reveng.sourceforge.net/crc-catalogue/)
for full details. The key parameter in identifying the variant is the
**check** value, the CRC checksum of the string `123456789`.

Ported to Elixir from Lammert Bies' [libCRC](https://github.com/lammertb/libcrc)
which seems to be the defacto implementation on StackExchange. Having looked
at and tried porting many C libs, I found they didn't adapt well to
functional recursion. All credit for the original work goes to Lammert.

It took me 3 days to convert 100 or so lines of C to 7 lines of Elixir :-)

I make no guarantees that this software works. Test it thoroughly before you
use it in your heart-lung machine.

## TL;DR

The API for this module is simple. Feed these a binary and it will poop out
an integer CRC value computed with a variant of the CRC algorithm:

  * crc16ccitt/1 - CRC16/CCITT
  * crc16xmodem/1 - CRC16/XMODEM
  * crc16kermit/1 - CRC16/KERMIT

## Installation

[Available in Hex](https://hex.pm/docs/publish). Install the package
by adding `ex_crc` to your list of dependencies in your `mix.exs`:

```elixir
def deps do
  [
    {:ex_crc, "~> 1.0.0"}
  ]
end
```

Find the docs at [https://hexdocs.pm/ex_crc](https://hexdocs.pm/ex_crc).

## Contributing

If your desired flavour isn't included, please feel free to add support and
shoot me a pull request. Please include the 4 test cases from the
[libCRC](https://github.com/lammertb/libcrc) test suite. If it proves
conformity I'll merge it.

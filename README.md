# IsType

[![Hex Version][hex-img]][hex] [![Hex Downloads][downloads-img]][downloads] [![License][license-img]][license]

[hex-img]: https://img.shields.io/hexpm/v/is_type.svg
[hex]: https://hex.pm/packages/is_type
[downloads-img]: https://img.shields.io/hexpm/dt/is_type.svg
[downloads]: https://hex.pm/packages/is_type
[license-img]: https://img.shields.io/badge/license-MIT-blue.svg
[license]: https://opensource.org/licenses/MIT

## Description

When used in a struct module, `IsType` automatically generates a method to
determine whether an object is of that type.

Instead of writing:

```elixir
assert Enum.all?(people, fn
  %Person{} -> true
  _ -> false
end)
```

`IsType` will let you write cleaner code:

```elixir
defmodule Person do
  use IsType

  defstruct id: nil, first_name: nil, last_name: nil
end

assert Enum.all?(people, &Person.is_person?/1)
```

or if you don't like the default name, specify your own with an atom.

```elixir
defmodule Person do
  use IsType, function_name: :is_employee

  defstruct id: nil, first_name: nil, last_name: nil
end

assert Enum.all?(people, &Person.is_employee/1)
```

## Installation

`IsType` can be installed by adding `is_type` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:is_type, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation can be found at [https://hexdocs.pm/is_type](https://hexdocs.pm/is_type).

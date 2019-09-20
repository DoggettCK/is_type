defmodule IsType do
  @moduledoc """
  When used in a struct module, automatically generates a method to determine whether an object is of that type.

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
  """

  defmacro __using__(options) do
    # For nested module (e.g. Foo.Bar), we just want Bar
    module_base_name =
      __CALLER__.module
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    options = Keyword.put_new(options, :function_name, :"is_#{module_base_name}?")

    quote bind_quoted: [caller_module: __CALLER__.module, options: options] do
      @doc """
      Returns `true` if `object` is a `#{inspect(caller_module)}`, `false` otherwise.
      """
      def unquote(Keyword.get(options, :function_name))(object) do
        # Have to call a function instead of pattern-matching in here on
        # object, because `defstruct` may not have been called, which would
        # make the user have to define the struct before calling `use IsType`.
        IsType.is_type?(object, unquote(caller_module))
      end
    end
  end

  @doc """
  Determines whether a provided struct is the specified module type.
  """
  def is_type?(%{__struct__: caller_module}, caller_module), do: true
  def is_type?(_non_struct, _caller_module), do: false
end

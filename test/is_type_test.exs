defmodule IsTypeTest do
  use ExUnit.Case
  doctest IsType

  describe "injects is_type_name? method" do
    defmodule Person do
      use IsType

      defstruct id: nil, name: nil
    end

    test "injected method properly matches against type" do
      assert Person.is_person?(%Person{id: 1, name: "Chris"})
      refute Person.is_person?(%{id: 1, name: "Chris"})
      refute Person.is_person?(DateTime.utc_now())
      refute Person.is_person?("not a struct")
      refute Person.is_person?(123.45)
    end
  end

  describe "behaves well with acronyms in module names" do
    defmodule HTTPResponse do
      use IsType

      defstruct body: nil, status_code: nil
    end

    test "injected method properly matches against type" do
      assert HTTPResponse.is_http_response?(%HTTPResponse{body: "", status_code: 200})
      refute HTTPResponse.is_http_response?(%{body: "", status_code: 200})
      refute HTTPResponse.is_http_response?(DateTime.utc_now())
      refute HTTPResponse.is_http_response?("not a struct")
      refute HTTPResponse.is_http_response?(123.45)
    end
  end

  describe "injects alternate named method" do
    defmodule DifferentName do
      use IsType, function_name: :is_the_expected_type

      defstruct name: nil
    end

    test "injected method properly matches against type" do
      assert DifferentName.is_the_expected_type(%DifferentName{name: "Chris"})
      refute DifferentName.is_the_expected_type(%{name: "Chris"})
      refute DifferentName.is_the_expected_type(DateTime.utc_now())
      refute DifferentName.is_the_expected_type("not a struct")
      refute DifferentName.is_the_expected_type(123.45)
    end

    test "default named function isn't injected" do
      assert_raise UndefinedFunctionError, fn ->
        DifferentName.is_different_name?(%DifferentName{name: "Chris"})
      end
    end
  end
end

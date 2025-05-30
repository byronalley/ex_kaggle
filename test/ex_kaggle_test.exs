defmodule ExKaggleTest do
  use ExUnit.Case
  doctest ExKaggle

  test "greets the world" do
    assert ExKaggle.hello() == :world
  end
end

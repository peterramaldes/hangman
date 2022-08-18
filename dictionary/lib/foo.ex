defmodule Foo do

  @doc """
  Function that takes two-element tuple as a parameter, and use pattern
  matching to return a two element tuple with the values swapped (so pass it
  `{2,5}` and you'll get `{5,2}` back).
  """
  def swap({a, b}), do: {b, a}

  def equal?(a, a), do: true
  def equal?(_, _), do: false

end

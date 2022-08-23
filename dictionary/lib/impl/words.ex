defmodule Dictionary.Impl.Words do

  @type t :: list(String.t)

  @spec word_list() :: t
  def word_list() do
    "assets/words.txt"
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  @spec random_word(list(String.t)) :: String.t
  def random_word(word_list) do
    word_list
    |> Enum.random()
  end

end

defmodule Dictionary do

  alias Dictionary.Impl.Words

  @opaque t :: Words.t()

  @spec start() :: t
  defdelegate start(), to: Words, as: :word_list

  @spec random_word(t) :: String.t
  defdelegate random_word(word_list), to: Words

end

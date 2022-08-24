defmodule Dictionary.Runtime.Server do

  @type t :: pid

  alias Dictionary.Impl.Words

  def start_link() do
    Agent.start_link(&Words.word_list/0)
  end

  def random_word(pid) do
    Agent.get(pid, &Words.random_word/1)
  end

end

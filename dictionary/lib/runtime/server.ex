defmodule Dictionary.Runtime.Server do

  @type t :: pid()

  alias Dictionary.Impl.Words

  @me __MODULE__

  def start_link do
    Agent.start_link(&Words.word_list/0, name: @me)
  end

  def random_word do
    Agent.get(@me, &Words.random_word/1)
  end

end

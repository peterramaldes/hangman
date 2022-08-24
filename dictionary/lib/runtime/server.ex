defmodule Dictionary.Runtime.Server do

  @type t :: pid()

  use Agent

  alias Dictionary.Impl.Words

  @me __MODULE__

  def start_link(_) do
    Agent.start_link(&Words.word_list/0, name: @me)
  end

  def random_word do
    if :rand.uniform < 0.33 do
      Agent.get(@me, fn _ -> exit(:boom) end)
    end
    Agent.get(@me, &Words.random_word/1)
  end

end

defmodule Hangman.Impl.Game do

  alias Hangman.Type 
  
  @type t :: %__MODULE__{
    game_state: Type.state(),
    letters:    list(String.t()),
    turns_left: integer,
    used:       MapSet.t(String.t())
  }

  defstruct(
    game_state: :initializing,
    letters:    [],
    turns_left: 7,
    used:       MapSet.new()
  )

  @spec new_game() :: t
  def new_game do
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.downcase() |> String.codepoints()
    }
  end

end

defmodule Hangman.Impl.Game do
  @type t :: %__MODULE__{
          game_state: Hangman.state(),
          letters: list(String.t()),
          turns_left: integer,
          used: MapSet.t(String.t())
        }

  defstruct(
    game_state: :initializing,
    letters: [],
    turns_left: 7,
    used: MapSet.new()
  )

  def new_game do
    new_game(Dictionary.random_word())
  end

  def new_game(word) do
    %__MODULE__{
      letters: word |> String.downcase() |> String.codepoints()
    }
  end
end

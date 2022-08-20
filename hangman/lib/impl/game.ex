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
    %__MODULE__{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end
end

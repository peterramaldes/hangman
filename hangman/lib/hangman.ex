defmodule Hangman do
  alias Hangman.Impl.Game

  @opaque game :: Game.t()

  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used
  @type tally :: %{
          game_state: state,
          letters: list(String.t()),
          turns_left: integer,
          used: list(String.t())
        }

  @spec new_game() :: game
  defdelegate new_game, to: Game

  @spec make_move(game, String.t()) :: {game, tally}
  def make_move(game, guess) do
  end
end

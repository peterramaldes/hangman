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
  def new_game() do
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.downcase() |> String.codepoints()
    }
  end

  @spec make_move(t, String.t()) :: {t, Type.tally}
  def make_move(game = %{ game_state: state }, _guess) 
  when state in [:won, :lost] do
    game 
    |> return_with_tally()
  end

  @spec make_move(t, String.t()) :: {t, Type.tally}
  def make_move(game, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  defp accept_guess(game, _guess, _already_used = true) do
    %{ game | game_state: :already_used }
  end 

  defp accept_guess(game, guess, _already_used) do
    %{ game | used: MapSet.put(game.used, guess) }
    |> score_guess(Enum.member?(game.letters, guess))
  end 

  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{ game | game_state: new_state }
  end

  defp score_guess(game = %{ turns_left: 1 }, _lost) do
    %{ game | game_state: :lost, turns_left: 0 }
  end

  defp score_guess(game, _bad_guess) do
    %{ game | game_state: :bad_guess, turns_left: game.turns_left - 1 }
  end

  defp return_with_tally(game) do
    { game, tally(game) }
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      letters:    reveal_guessed_letters(game),
      turns_left: game.turns_left,
      used:       game.used |> MapSet.to_list |> Enum.sort
    }
  end

  defp reveal_guessed_letters(game = %{ game_state: :lost }) do
    game.letters
  end

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_won(true),  do: :won
  defp maybe_won(_),     do: :good_guess

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _letter), do: "_"

end

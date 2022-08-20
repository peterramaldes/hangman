defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary
  alias Hangman.Impl.Game

  test "new game returns the structure" do
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
  end

  test "new game returns the correct word" do
    game = Game.new_game("wombat")
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end
end

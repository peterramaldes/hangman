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

  test "check each element is lower-case ASCII character" do
    game = Game.new_game("RONALDO")

    game.letters
    |> Enum.each(fn letter -> assert letter =~ ~r/[a-z]/ end)
  end

  # TODO: add test to verify if new_game received some number
  # test "check each element is a letter" do
  #   game = Game.new_game("1234")
  #   game.letters
  #   |> Enum.each(fn letter -> assert letter =~ ~r/[a-z]/ end)
  # end
end

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

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      { new_game, _tally } = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicated letter is reported" do
    game = Game.new_game()

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state !== :already_used
    
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state !== :already_used

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used

  end

  test "we record letters used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  # TODO: add test to verify if new_game received some number
  # test "check each element is a letter" do
  #   game = Game.new_game("1234")
  #   game.letters
  #   |> Enum.each(fn letter -> assert letter =~ ~r/[a-z]/ end)
  # end
end

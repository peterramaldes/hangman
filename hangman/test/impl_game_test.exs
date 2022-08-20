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

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")
    { _game, tally } = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
    { _game, tally } = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in the word" do
    game = Game.new_game("wombat")
    { _game, tally } = Game.make_move(game, "j")
    assert tally.game_state == :bad_guess

    { _game, tally } = Game.make_move(game, "t")
    assert tally.game_state == :good_guess
    { _game, tally } = Game.make_move(game, "m")
    assert tally.game_state == :good_guess

    { _game, tally } = Game.make_move(game, "k")
    assert tally.game_state == :bad_guess
  end

  test "can handle a sequence of moves" do
    [
      [ "a", :bad_guess,     6,  [ "_", "_", "_", "_", "_" ],  [ "a" ] ],
      [ "a", :already_used,  6,  [ "_", "_", "_", "_", "_" ],  [ "a" ] ],
      [ "e", :good_guess,    6,  [ "_", "e", "_", "_", "_" ],  [ "a", "e" ] ],
      [ "x", :bad_guess,     5,  [ "_", "e", "_", "_", "_" ],  [ "a", "e", "x" ] ],
    ]
    |> test_sequence_of_moves()
  end

  test "can handle a winning game" do
    [
      [ "a", :bad_guess,     6,  [ "_", "_", "_", "_", "_" ],  [ "a" ] ],
      [ "a", :already_used,  6,  [ "_", "_", "_", "_", "_" ],  [ "a" ] ],
      [ "e", :good_guess,    6,  [ "_", "e", "_", "_", "_" ],  [ "a", "e" ] ],
      [ "x", :bad_guess,     5,  [ "_", "e", "_", "_", "_" ],  [ "a", "e", "x" ] ],
      [ "h", :good_guess,    5,  [ "h", "e", "_", "_", "_" ],  [ "a", "e", "h", "x" ] ],
      [ "l", :good_guess,    5,  [ "h", "e", "l", "l", "_" ],  [ "a", "e", "h", "l", "x" ] ],
      [ "o", :won,           5,  [ "h", "e", "l", "l", "o" ],  [ "a", "e", "h", "l", "o", "x" ] ],
    ]
    |> test_sequence_of_moves()
  end

  test "can handle a failing game" do
    [
      [ "a", :bad_guess,     6,  [ "_", "_", "_", "_", "_" ],  [ "a" ] ],
      [ "a", :already_used,  6,  [ "_", "_", "_", "_", "_" ],  [ "a" ] ],
      [ "e", :good_guess,    6,  [ "_", "e", "_", "_", "_" ],  [ "a", "e" ] ],
      [ "i", :bad_guess,     5,  [ "_", "e", "_", "_", "_" ],  [ "a", "e", "i" ] ],
      [ "o", :good_guess,    5,  [ "_", "e", "_", "_", "o" ],  [ "a", "e", "i", "o" ] ],
      [ "u", :bad_guess,     4,  [ "_", "e", "_", "_", "o" ],  [ "a", "e", "i", "o", "u" ] ],
      [ "j", :bad_guess,     3,  [ "_", "e", "_", "_", "o" ],  [ "a", "e", "i", "j", "o", "u" ] ],
      [ "k", :bad_guess,     2,  [ "_", "e", "_", "_", "o" ],  [ "a", "e", "i", "j", "k", "o", "u" ] ],
      [ "w", :bad_guess,     1,  [ "_", "e", "_", "_", "o" ],  [ "a", "e", "i", "j", "k", "o", "u", "w" ] ],
      [ "z", :lost,          0,  [ "_", "e", "_", "_", "o" ],  [ "a", "e", "i", "j", "k", "o", "u", "w", "z" ] ],
    ]
    |> test_sequence_of_moves()
  end



  def test_sequence_of_moves(script) do
    game = Game.new_game("hello")

    script
    |> Enum.reduce(game, &check_one_move/2)
  end

  def check_one_move([ guess, state, turns, letters, used], game) do
    { game, tally } = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters    == letters
    assert tally.used       == used

    game
  end

end

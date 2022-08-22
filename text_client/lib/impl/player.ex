defmodule TextClient.Impl.Player do

  @typep game  :: Hangman.game
  @typep tally :: Hangman.tally
  @typep state :: { game, tally }

  @spec start() :: :ok
  def start() do
    game  = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({ game, tally })
  end

  @spec interact(state) :: :ok
  def interact({_game, _tally = %{ game_state: :won }}) do
    IO.puts("Congratulations. You won!")
  end 

  def interact({_game, tally = %{ game_state: :lost }}) do
    IO.puts("Sorry. You lost.. the word was #{tally.letters |> Enum.join}")
  end 

  def interact({ game, tally }) do
    IO.puts(feedback_for(tally))
    # Display current word
    # Get next guess
    # Make move
    # interact()
  end

  # @type state :: :initializing | :good_guess | :bad_guess | :already_used

  defp feedback_for(tally = %{ game_state: :initializing }) do
    "Welcome! I'm thinking for a #{tally.letters |> length} letter word"
  end 

  defp feedback_for(%{ game_state: :good_guess }), do: "Good guess!"
  defp feedback_for(%{ game_state: :bad_guess }),  do: "Bad guess!"
  defp feedback_for(%{ game_state: :already_used }) do
    "You already used that letter"
  end

end

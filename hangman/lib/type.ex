defmodule Hangman.Type do

  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  @type tally :: %{
    game_state: state,
    letters:    list(String.t()),
    turns_left: integer,
    used:       list(String.t())
  }

end

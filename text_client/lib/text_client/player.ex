defmodule TextClient.Player do
  alias TextClient.{Mover, Prompter, Summary, State}

  def play(%State{tally: %{ game_state: :won}}) do
    exit_with_message "You WON!"
  end

  def play(%State{tally: %{ game_state: :lost}}) do
    exit_with_message "You LOST! Better luck next time :("
  end

  def play(state = %State{tally: %{ game_state: :good_guess}}) do
    continue_with_message(state, "Good guess")
  end

  def play(state = %State{tally: %{ game_state: :bad_guess}}) do
    continue_with_message(state,  "Bad guess, try again")
  end

  def play(state = %State{tally: %{ game_state: :already_used}}) do
    continue_with_message(state,  "You already guessed that letter")
  end

  def play(state) do
    continue_with_message(state,  "Welcome to hangman, start guessing :)")
  end

##############################################################################

  defp continue(state) do
    state
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.move()
    |> play()
  end

  defp exit_with_message(message) do
    IO.puts message
    exit(:normal)
  end

  defp continue_with_message(state, message) do
    IO.puts message
    continue(state)
  end
end

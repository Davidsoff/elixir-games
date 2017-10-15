defmodule TextClient.Summary do
  alias TextClient.State

  def display(state = %State{tally: tally}) do
    IO.puts [
      "#{IO.ANSI.clear()}",
      "Word so far: #{Enum.join(tally.letters, " ")}\n",
      "Guesses left: #{tally.turns_left}\n",
      "Letters used: #{Enum.join(tally.used, " ")}\n\n",
    ]
    state
  end
end

defmodule Hangman.Game do
  alias __MODULE__

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters:    [],
    used:       MapSet.new(),
  )

  def new_game(word, max_turns) do
    %Game{
      letters: word |> String.codepoints,
      turns_left: max_turns
    }
  end

  def new_game(word) do
    new_game(word, 7)
  end

  def new_game() do
    Dictionary.random_word()
    |> new_game
  end

  def make_move(game = %Game{game_state: state}, _guess)
  when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game, guess) do
    game
    |> accept_move(guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  def tally(game = %Game{game_state: state})
  when state == :lost do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    game.letters,
      used:       game.used,
    }
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    game.letters |> reveal_guessed(game.used),
      used:       game.used,
    }
  end

  ##########################################################


  defp accept_move(game, _guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _good_guess = true) do
    new_state = MapSet.new(game.letters)
    |> MapSet.subset?(game.used)
    |> maybe_won
    Map.put(game, :game_state, new_state)
  end

  defp score_guess(game = %Game{ turns_left: 1}, _not_good_guess) do
    Map.put(game, :turns_left, 0)
    |> Map.put(:game_state, :lost)
  end

  defp score_guess(game = %Game{ turns_left: turns_left}, _not_good_guess) do
    %{ game |
       game_state: :bad_guess,
       turns_left: turns_left-1,
    }
  end

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp return_with_tally(game), do: {game, tally(game)}

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _not_in_word),   do: "_"

  defp maybe_won(true), do: :won
  defp maybe_won(_),    do: :good_guess

end

defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game


  test "new_game returns correct initial state" do
    game = Game.new_game()
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert MapSet.size(game.used) == 0
  end

  test "state isn't changed for :won and :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert {^game, _tally} = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    {game, _tally} = Game.new_game()
           |> Game.make_move("x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is already used" do
    {game, _tally} = Game.new_game()
           |> Game.make_move("x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a guessed word is a won game" do
    game = Game.new_game("pop")
    moves = [
      {"p", :good_guess},
      {"o", :won},
    ]
    assert_correct_moves(game, moves, 7)
  end

  test "a game can be lost" do
    game = Game.new_game("pop", 2)
    moves = [
      {"1", :bad_guess},
      {"7", :lost},
    ]
    assert_correct_moves(game, moves, 0)
  end

  defp assert_correct_moves(game, moves, moves_left) do
    end_state = Enum.reduce(moves, game, fn(_x = {guess, result}, new_game) ->
      {new_game, _tally} = Game.make_move(new_game, guess)
      assert new_game.game_state == result
      new_game
    end)
    assert end_state.turns_left == moves_left
  end

end

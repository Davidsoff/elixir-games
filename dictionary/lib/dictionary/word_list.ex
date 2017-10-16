defmodule Dictionary.WordList do

  def start_link() do
    Agent.start_link(&start/0)
  end

  def start() do
    "../../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def random_word(agent) do
    Agent.get(agent, &Enum.random/1)
  end
end

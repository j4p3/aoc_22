defmodule Aoc22 do
  @moduledoc """
  Advent of Code 2022 Elixir solutions
  https://adventofcode.com/2022/
  @j4p3
  """
  alias Util.Numbers

  def run() do
    for d <- 1..25, do: run(d)
  end

  @spec run(integer(), integer() | nil) :: any()
  def run(day, part \\ nil) do
    day = day
    |> num_word()
    |> String.capitalize()

    apply(:"Aoc22.#{day}", :"#{num_word(part)}", [])
  end

  defp num_word(nil), do: "run"
  defp num_word(day_number), do: Numbers.to_word(day_number)
end

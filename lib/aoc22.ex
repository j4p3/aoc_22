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
  def run(day_num, part \\ nil) do
    day = day_num
    |> word_for_num()
    |> String.capitalize()

    apply(:"Elixir.Aoc22.#{day}", :"#{word_for_num(part)}", [])
  end

  defp word_for_num(nil), do: "run"
  defp word_for_num(day_number), do: Numbers.to_word(day_number)
end

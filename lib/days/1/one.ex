defmodule Aoc22.One do
  @moduledoc """
  Day 1: Calorie Counting
  https://adventofcode.com/2022/day/1
  """
  alias Aoc22.Util.Files
  alias Aoc22.Util.Strings
  @day 1

  def run() do
    one()
    two()
  end

  def one(input_type \\ :input, input_num \\ 1) do
    parse_input(input_type, input_num)
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def two(input_type \\ :input, input_num \\ 1) do
    parse_input(input_type, input_num)
  end

  defp parse_input(input_type, input_num) do
    tokenizer = fn chunk ->
      Strings.tokenize(chunk, &String.to_integer/1, "\n")
    end

    Files.file_for(@day, input_type, input_num)
    |> Strings.tokenize(
      tokenizer,
      "\n\n"
    )
  end
end

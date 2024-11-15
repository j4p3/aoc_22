defmodule Aoc22.Three do
  @moduledoc """
  Day 3: Rucksack Reorganization
  https://adventofcode.com/2022/day/3
  """
  alias Aoc22.Util.Files
  alias Aoc22.Util.Strings

  @day 3

  def run() do
    {one(), two()}
  end

  def one(input_type \\ :input, input_num \\ 1) do
    parse_input(input_type, input_num)
    |> Enum.map(&split_line/1)
    |> Enum.map(&common_letter/1)
    |> evaluate_priorities()
  end

  def two(input_type \\ :input, input_num \\ 1) do
    parse_input(input_type, input_num)
    |> Enum.chunk_every(3)
    |> Enum.map(&common_letter/1)
    |> evaluate_priorities()
  end

  def split_line(line) do
    line
    |> Enum.split(div(length(line), 2))
    |> Tuple.to_list()
  end

  def common_letter([head, second | lists]) do
    common_seed = MapSet.intersection(MapSet.new(head), MapSet.new(second))
    lists
    |> Enum.reduce(common_seed, fn next_list, common ->
      MapSet.intersection(common, MapSet.new(next_list))
    end)
    |> MapSet.to_list()
    |> Enum.at(0) # expect only one common letter
  end

  def evaluate_priorities(common_letters) do
    common_letters
    |> Enum.map(&Strings.to_ascii_ints/1)
    |> List.flatten()
    |> Enum.sum()
  end

  defp parse_input(input_type, input_num) do
    Files.file_for(@day, input_type, input_num)
    |> String.split()
    |> Enum.map(&String.codepoints/1)
  end
end

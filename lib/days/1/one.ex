defmodule Aoc22.One do
  @moduledoc """
  Day 1: Calorie Counting
  https://adventofcode.com/2022/day/1
  """
  alias Aoc22.Util.Files
  alias Aoc22.Util.Strings

  @day 1

  @type calorie_inventory :: [integer()]

  @type calorie_inventory_list :: [calorie_inventory()]

  def run() do
    {one(), two()}
  end

  def one(input_type \\ :input, input_num \\ 1) do
    parse_input(input_type, input_num)
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def two(input_type \\ :input, input_num \\ 1) do
    parse_input(input_type, input_num)
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end

  @spec build_calorie_inventory_list(String.t()) :: calorie_inventory_list()
  defp build_calorie_inventory_list(calorie_counts) do
    Strings.tokenize(calorie_counts, &build_calorie_inventory/1, "\n\n")
  end

  @spec build_calorie_inventory(String.t()) :: calorie_inventory()
  defp build_calorie_inventory(counts) do
    Strings.tokenize(counts, &String.to_integer/1, "\n")
  end

  defp parse_input(input_type, input_num) do
    Files.file_for(@day, input_type, input_num)
    |> build_calorie_inventory_list()
  end
end

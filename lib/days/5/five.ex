defmodule Aoc22.Five do
  @moduledoc """
  Day 5: Supply Stacks
  https://adventofcode.com/2022/day/5
  """
  alias Aoc22.Util.Files

  @day 5

  @type stack :: [integer()]
  @type stacks :: [stack()]
  @type instruction :: {integer(), integer(), integer()}

  def run() do
    {one(), two()}
  end

  def one(input_type \\ :input, input_num \\ 1) do
    {stacks, instructions} = parse_input(input_type, input_num)

    Enum.reduce(instructions, stacks, &move/2)
    |> Enum.map(&Enum.take(&1, 1))
    |> Enum.join()
  end

  def two(input_type \\ :input, input_num \\ 1) do
    {stacks, instructions} = parse_input(input_type, input_num)

    Enum.reduce(instructions, stacks, &move(&1, &2, false))
    |> Enum.map(&Enum.take(&1, 1))
    |> Enum.join()
  end

  def move({count, from, to}, stacks, reverse \\ true) do
    from_stack = Enum.at(stacks, from)
    to_stack = Enum.at(stacks, to)
    cargo = Enum.take(from_stack, count)
    cargo = if reverse, do: Enum.reverse(cargo), else: cargo

    stacks
    |> List.replace_at(to, Enum.concat(cargo, to_stack))
    |> List.replace_at(
      from,
      Enum.take(from_stack, -(length(from_stack) - count))
    )
  end

  def create_stacks(drawing) do
    lines =
      drawing
      |> String.split("\n", trim: true)
      |> then(fn lines -> Enum.take(lines, length(lines) - 1) end)
      |> Enum.map(fn line -> " " <> line end)

    stack_width = String.length(Enum.at(lines, 0))
    stack_count = div(stack_width, 4)
    stacks = for _ <- 1..stack_count, do: []

    lines
    |> Enum.reduce(stacks, fn line, stacks ->
      crates = for i <- 2..stack_width//4, do: String.at(line, i)

      Enum.with_index(crates)
      |> Enum.reduce(stacks, fn {char, idx}, stacks ->
        if char != " " do
          List.replace_at(stacks, idx, [char | Enum.at(stacks, idx)])
        else
          stacks
        end
      end)
    end)
    |> Enum.map(&Enum.reverse/1)
  end

  def create_instructions(instructions_body) do
    instructions_body
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_instruction_line/1)
  end

  def parse_instruction_line(instruction) do
    i = String.split(instruction)

    {String.to_integer(Enum.at(i, 1)), String.to_integer(Enum.at(i, 3)) - 1,
     String.to_integer(Enum.at(i, 5)) - 1}
  end

  def parse_input(input_type, input_num) do
    [drawing, instructions] =
      Files.file_for(@day, input_type, input_num)
      |> String.split("\n\n")

    {create_stacks(drawing), create_instructions(instructions)}
  end
end

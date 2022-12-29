defmodule Aoc22.Two do
  @moduledoc """
  Day 2: Rock Paper Scissors
  https://adventofcode.com/2022/day/2
  """
  alias Aoc22.Util.Files
  alias Aoc22.Util.Strings

  @day 2

  defmodule Rps do
    defstruct type: nil, outcome: nil

    @spec new_one(String.t()) :: %__MODULE__{outcome: nil, type: :p | :r | :s}
    def new_one("A"), do: %__MODULE__{type: :r}
    def new_one("B"), do: %__MODULE__{type: :p}
    def new_one("C"), do: %__MODULE__{type: :s}
    def new_one("X"), do: %__MODULE__{type: :r}
    def new_one("Y"), do: %__MODULE__{type: :p}
    def new_one("Z"), do: %__MODULE__{type: :s}

    @spec new_two(String.t()) :: %__MODULE__{
            outcome: :d | :l | :w | nil,
            type: :p | :r | :s | nil
          }
    def new_two("A"), do: %__MODULE__{type: :r}
    def new_two("B"), do: %__MODULE__{type: :p}
    def new_two("C"), do: %__MODULE__{type: :s}
    def new_two("X"), do: %__MODULE__{outcome: :l}
    def new_two("Y"), do: %__MODULE__{outcome: :d}
    def new_two("Z"), do: %__MODULE__{outcome: :w}

    @spec play(%__MODULE__{}, %__MODULE__{}) :: integer()
    def play(%__MODULE__{outcome: outcome, type: self}, %__MODULE__{type: other} = other_cast)
        when self == nil do
      case {outcome, other} do
        {:w, :r} -> play(%__MODULE__{type: :p}, other_cast)
        {:l, :r} -> play(%__MODULE__{type: :s}, other_cast)
        {:d, :r} -> play(%__MODULE__{type: :r}, other_cast)
        {:w, :p} -> play(%__MODULE__{type: :s}, other_cast)
        {:l, :p} -> play(%__MODULE__{type: :r}, other_cast)
        {:d, :p} -> play(%__MODULE__{type: :p}, other_cast)
        {:w, :s} -> play(%__MODULE__{type: :r}, other_cast)
        {:l, :s} -> play(%__MODULE__{type: :p}, other_cast)
        {:d, :s} -> play(%__MODULE__{type: :s}, other_cast)
      end
    end

    def play(%__MODULE__{type: self}, %__MODULE__{type: other}) do
      case {self, other} do
        {:r, :r} -> 1 + 3
        {:r, :p} -> 1 + 0
        {:r, :s} -> 1 + 6
        {:p, :p} -> 2 + 3
        {:p, :r} -> 2 + 6
        {:p, :s} -> 2 + 0
        {:s, :s} -> 3 + 3
        {:s, :r} -> 3 + 0
        {:s, :p} -> 3 + 6
      end
    end
  end

  def run() do
    {one(), two()}
  end

  def one(input_type \\ :input, input_num \\ 1) do
    tokenize_round = fn move_str ->
      Rps.new_one(move_str)
    end

    parse_input(input_type, input_num)
    |> Strings.tokenize(fn round_str ->
      List.to_tuple(Strings.tokenize(round_str, tokenize_round, " "))
    end)
    |> Enum.reduce(0, fn {opponent, self}, score ->
      score + Rps.play(self, opponent)
    end)
  end

  def two(input_type \\ :input, input_num \\ 1) do
    tokenize_round = fn move_str ->
      Rps.new_two(move_str)
    end

    parse_input(input_type, input_num)
    |> Strings.tokenize(fn round_str ->
      List.to_tuple(Strings.tokenize(round_str, tokenize_round, " "))
    end)
    |> Enum.reduce(0, fn {opponent, outcome}, score ->
      score + Rps.play(outcome, opponent)
    end)
  end

  defp parse_input(input_type, input_num) do
    Files.file_for(@day, input_type, input_num)
  end
end

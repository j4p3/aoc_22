defmodule Aoc22.Util.Lists do
  @spec to_numbers([String.t()]) :: [integer()]
  def to_numbers(list) do
    list
    |> Enum.map(&String.to_integer/1)
  end
end

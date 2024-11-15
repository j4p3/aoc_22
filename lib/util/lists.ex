defmodule Aoc22.Util.Lists do
  @spec to_numbers([String.t()]) :: [integer()]
  def to_numbers(list) do
    list
    |> Enum.map(&String.to_integer/1)
  end

  @spec to_map_index([any()]) :: %{integer() => any()}
  def to_map_index(list) do
    {_, result} =
      list
      |> Enum.reduce({0, Map.new()}, fn el, {i, map} ->
        {i + 1, Map.put(map, i, el)}
      end)

    result
  end
end

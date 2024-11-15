defmodule Aoc22.Eight do
  @moduledoc """
  Day 8: Treetop Tree House
  https://adventofcode.com/2022/day/8
  """
  alias Aoc22.Util.Grid
  alias Aoc22.Util.Files
  alias Aoc22.Util.Strings
  alias Aoc22.Util.Lists
  require Nx

  @day 8

  @type row :: %{integer() => integer()}
  @type grid :: %{integer() => row()}
  @type coord :: {integer(), integer()}
  @type axis_maxes :: [integer()]
  @type max_coords :: MapSet[coord()]

  @type visibility_axis_max :: {integer(), integer()}
  @type visibility_axis_maxes :: [visibility_axis_max() | visibility_axis_max()]

  @type coordinate_visibility :: %{coord() => [coord()]}

  def run() do
    {one(), two()}
  end

  def one(input_type \\ :input, input_num \\ 1) do
    {_, coordinates} =
      parse_input(input_type, input_num)
      |> visible_trees()

    MapSet.size(coordinates)
  end

  def two(input_type \\ :input, input_num \\ 1) do
    parse_input(input_type, input_num)
    |> tree_visibility()
  end

  def visible_trees(grid) do
    size = map_size(grid) - 1

    for i <- 0..size,
        j <- 0..size,
        reduce: {[-1, -1, -1, -1], MapSet.new()} do
      {axis_maxes, max_coords} ->
        IO.puts("(#{i},#{j}): #{get_in(grid, [i, j])}")

        {axis_maxes, max_coords} =
          coordinates_for({i, j}, size)
          |> Enum.map(fn coordinate ->
            {coordinate, get_in(grid, Tuple.to_list(coordinate))}
          end)
          # {coordinate, value}
          |> Enum.zip(axis_maxes)
          # {{coordinate, value}, axis_max}
          |> Enum.reduce({[], max_coords}, fn {{coordinate, value}, axis_max},
                                              {new_maxes, max_coords} ->
            if value > axis_max do
              IO.puts(
                "found new max at (#{elem(coordinate, 0)}, #{elem(coordinate, 1)}): #{value} > #{axis_max}"
              )

              {[value | new_maxes], MapSet.put(max_coords, coordinate)}
            else
              {[axis_max | new_maxes], max_coords}
            end
          end)
          |> then(fn {axis_maxes, max_coords} -> {Enum.reverse(axis_maxes), max_coords} end)

        # reset axis maxes at end of each axis traversal
        axis_maxes =
          case {i, j} do
            {_, ^size} ->
              IO.puts("#{j} == #{size}, resetting axis_maxes")
              [-1, -1, -1, -1]

            _ ->
              axis_maxes
          end

        {axis_maxes, max_coords}
    end
  end

  def tree_visibility(grid) do
    size = map_size(grid) - 1

    acc =
      for i <- 0..size,
          j <- 0..size,
          dim <- [:>, :v, :<, :^],
          reduce: {%{:> => [], :v => [], :< => [], :^ => []}, %{}} do
        {axis_counts, visible_coords} ->

          coord = coordinate_for({i, j}, size, dim)
          value = get_in(grid, Tuple.to_list(coord))
          active_coords = Map.get(axis_counts, dim)

          IO.puts(
            "(#{i}, #{j}) #{dim}: (#{elem(coord, 0)}, #{elem(coord, 1)}): #{get_in(grid, Tuple.to_list(coord))}"
          )
          # {active_coords, visible_coords} =
          # Enum.reduce(
          #   active_coords,
          #   {[], visible_coords},
              # fn c, {active_acc, visible_acc} ->
              #   vis = Map.put(c, MapSet.put(Map.get(visible_coords, c), coord))

              #   if get_in(grid, Tuple.to_list(c)) > value do
              #     {[c | active_acc], vis}
              #   else
              #     {active_acc, vis}
              #   end
              # end
          # )

          # {axis_max, active_coords} = Map.get(axis_counts, dim)

          # Map.put(coords, coord, 0)

          # keep a list of coords still being counted on this axis. for each, increment or remove from active list.
          # keep a global list of coords and their total count along each axis.
          # what we're doing is linearizing this problem - the inner loop is a straightforward line count
          # we will later reconcile this into a two-dimensional solution

          #  but - single axis_max and list of coords being counted isn't good enough. each coord being counted is its own max
          # when it's exceeded, we stop counting it in that direction

          {axis_counts, active_coords}
      end
  end

  def coordinates_for({y, x}, size) do
    [
      {y, x},
      {y, size - x},
      {x, y},
      {size - x, y}
    ]
  end

  def coordinate_for({y, x}, _size, :>), do: {y, x}
  def coordinate_for({y, x}, size, :<), do: {y, size - x}
  def coordinate_for({y, x}, _size, :v), do: {x, y}
  def coordinate_for({y, x}, size, :^), do: {size - x, y}

  def parse_input(input_type, input_num) do
    Files.file_for(@day, input_type, input_num)
    |> Strings.tokenize(&Strings.to_ints/1)
    |> Enum.map(&Lists.to_map_index/1)
    |> Lists.to_map_index()
  end

  def parse_input_to_tensor(input_type, input_num) do
    Files.file_for(@day, input_type, input_num)
    |> Strings.tokenize(&Strings.to_ints/1)
    |> Nx.tensor(type: :u8)
  end

  def parse_input_to_graph(input_type, input_num) do
    Files.file_for(@day, input_type, input_num)
    |> Strings.tokenize(&Strings.to_ints/1)
    # |> Grid.from_arrays()
  end
end

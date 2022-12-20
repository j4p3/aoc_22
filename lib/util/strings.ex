defmodule Aoc22.Util.Strings do
  @spec tokenize(binary, fun() | nil, binary | [nonempty_binary] | :binary.cp() | nil) :: list
  def tokenize(body, transformation_fn \\ &String.to_integer/1, delimiter \\ "\n") do
    # argument error giving pattern to splitter
    # pattern = :binary.compile_pattern(delimiter)
    String.splitter(body, delimiter, trim: true)
    |> Enum.map(&apply(transformation_fn, [&1]))
  end
end

defmodule Aoc22.Util.Strings do
  @spec tokenize(binary, fun() | nil, binary | [nonempty_binary] | :binary.cp() | nil) :: list
  def tokenize(body, transformation_fn \\ &String.to_integer/1, delimiter \\ "\n") do
    # argument error giving pattern to splitter
    # pattern = :binary.compile_pattern(delimiter)
    String.splitter(body, delimiter, trim: true)
    |> Enum.map(&apply(transformation_fn, [&1]))
  end

  @spec to_ints(String.t()) :: [integer()]
  def to_ints(body) do
    body
    |> String.codepoints()
    |> Enum.map(&String.to_integer/1)
  end

  @spec to_ascii_ints(String.t()) :: [integer()]
  def to_ascii_ints(body) do
    body
    |> String.to_charlist()
    |> Enum.map(fn char ->
      if char >= 97 do
        # ASCII lowercase start (1)
        char - 96
      else
        # ASCII uppercase start (27)
        char - 38
      end
    end)
  end
end

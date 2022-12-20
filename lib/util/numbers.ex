defmodule Util.Numbers do
  @numbers %{
    1 => "one",
    2 => "two",
    3 => "three",
    4 => "four",
    5 => "five",
    6 => "six",
    7 => "seven",
    8 => "eight",
    9 => "nine",
    10 => "",
    11 => "",
    12 => "",
    13 => "",
    14 => "",
    15 => "",
    16 => "",
    17 => "",
    18 => "",
    19 => "",
    20 => "",
    21 => "",
    22 => "",
    23 => "",
    24 => "",
    25 => "",

  }
  @spec to_word(integer()) :: String.t()
  def to_word(number) do
    Map.get(@numbers, number, "")
  end
end

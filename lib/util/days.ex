defmodule Util.Days do
  alias Util.Numbers

  @spec new(integer) :: :ok | {:error, String.t()}
  def new(num) do
    num_str = Integer.to_string(num)
    day = Numbers.to_word(num)
    capital = String.capitalize(day)

    file = "defmodule Aoc22.#{capital} do
      @moduledoc \"\"\"
      Day #{num_str}
      https://adventofcode.com/2022/day/#{num_str}
      \"\"\"
      alias Aoc22.Util.Files
      alias Aoc22.Util.Strings

      @day #{num_str}

      def run() do
        {one(), two()}
      end

      def one(input_type \\\\ :input, input_num \\\\ 1) do
      end

      def two(input_type \\\\ :input, input_num \\\\ 1) do
      end

      defp parse_input(input_type, input_num) do
        Files.file_for(@day, input_type, input_num)
      end
    end"

    path = "#{File.cwd!()}/lib/days/#{num_str}"
    File.mkdir("#{path}")
    File.mkdir("#{path}/data")
    File.write("#{path}/data/example_1.txt", "")
    File.write("#{path}/data/input.txt", "")
    File.write("#{path}/#{day}.ex", file)
  end
end

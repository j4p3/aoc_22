defmodule Aoc22.Util.Files do
  @spec file_for(integer, atom, integer) :: String.t()
  def file_for(day_num, input_type, input_num) do
    filename =
      case input_type do
        :example -> "example_#{input_num}.txt"
        :input -> "input.txt"
      end

    "#{File.cwd!()}/lib/days/#{Integer.to_string(day_num)}/data/#{filename}"
    |> File.read!()
  end
end

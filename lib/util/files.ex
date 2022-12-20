defmodule Aoc22.Util.Files do
  @spec file_for(integer, atom, integer) :: <<_::64, _::_*8>>
  def file_for(day_num, input_type, input_num) do
    "#{File.cwd!()}/lib/days/#{Integer.to_string(day_num)}/#{Atom.to_string(input_type)}/#{Integer.to_string(input_num)}.txt"
    |> File.read!()
  end
end

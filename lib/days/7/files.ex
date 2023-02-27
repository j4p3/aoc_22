defmodule Aoc22.Seven.ElfDir do
  defstruct name: nil, size: 0, children: []
  @type t :: %__MODULE__{children: [%__MODULE__{}], name: String.t()}

  def new(name \\ nil) do
    %__MODULE__{
      name: name
    }
  end

  defp size(dir), do: dir.size

  def traverse(dir, func \\ &size/1, results \\ [])

  def traverse(%__MODULE__{} = dir, func, results) do
    dir_results = Enum.map(dir.children, func)

    dir_results ++ results
  end
end

defmodule Aoc22.Seven.ElfFile do
  defstruct name: nil, size: 0
end

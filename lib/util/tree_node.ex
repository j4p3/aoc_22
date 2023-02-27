defmodule Util.TreeNode do
  defstruct children: [], value: [], name: nil
  @type t :: %__MODULE__{children: [%__MODULE__{}], value: any(), name: String.t()}

  @spec insert(t(), any()) :: t()
  def insert(node, value) do
    %__MODULE__{
      node
      | children: [
          %__MODULE__{
            value: value
          }
          | node.children
        ]
    }
  end

  def new(value \\ nil) do
    %__MODULE__{
      value: value
    }
  end
end

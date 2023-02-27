defmodule :_exit do
  defdelegate exit(), to: System, as: :halt
end

defmodule :_shortcuts do
  defdelegate c, to: IEx.Helpers, as: :clear
  defdelegate r, to: IEx.Helpers, as: :recompile
end

import :_exit
import :_shortcuts

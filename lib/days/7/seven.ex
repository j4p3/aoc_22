defmodule Aoc22.Seven do
  @moduledoc """
  Day 7: No Space Left On Device
  https://adventofcode.com/2022/day/7
  """
  alias Aoc22.Util.Files
  alias Aoc22.Util.Strings
  alias Aoc22.Seven.ElfDir
  alias Aoc22.Seven.ElfFile

  @day 7

  def run() do
    {one(), two()}
  end

  @doc """
  Read instruction list into tree, walk tree accumulating sizes below threshold
  """
  def one(input_type \\ :input, input_num \\ 1) do
    [{:cd, fs_root} | instructions] = parse_input(input_type, input_num)
    root_dir = %ElfDir{name: fs_root}

    build_tree(root_dir, instructions)
    |> then(&dir_sizes_below(&1, 100_000))
    |> Enum.sum()
  end

  @doc """
  Read instruction list into tree, calculate space needed, walk tree accumulating sizes, pick smallest size greater than space needed
  """
  def two(input_type \\ :input, input_num \\ 1, fs_size \\ 70_000_000, update_size \\ 30_000_000) do
    [{:cd, fs_root} | instructions] = parse_input(input_type, input_num)
    root_dir = %ElfDir{name: fs_root}

    tree = build_tree(root_dir, instructions)
    target_size = update_size - (fs_size - tree.size)

    sizes =
      tree
      |> dir_sizes()
      |> Enum.sort()

    Enum.reduce_while(sizes, false, fn
      size, _acc when size > target_size ->
        {:halt, size}

      _size, acc ->
        {:cont, acc}
    end)
  end

  defp dir_sizes(dir, sizes \\ [])
  defp dir_sizes(%ElfFile{} = _, sizes), do: sizes

  defp dir_sizes(%ElfDir{size: size, children: children} = _, sizes) do
    child_dirs =
      Enum.map(children, fn
        %ElfDir{} = c -> c
        %ElfFile{} = _c -> false
      end)
      |> Enum.filter(& &1)

    Enum.concat([[size], sizes, Enum.map(child_dirs, &dir_sizes(&1, []))])
    |> List.flatten()
  end

  defp dir_sizes_below(dir, max, sizes \\ [])

  defp dir_sizes_below(%ElfFile{} = _, _max, _sizes), do: []

  defp dir_sizes_below(%ElfDir{size: size, children: children}, max, sizes) do
    sizes =
      if size > max do
        sizes
      else
        [size | sizes]
      end

    sizes ++
      (Enum.map(children, fn
         %ElfDir{} = c -> dir_sizes_below(c, max, [])
         %ElfFile{} = _c -> false
       end)
       |> Enum.filter(& &1)
       |> List.flatten())
  end

  defp build_tree(dir, []), do: dir
  defp build_tree(dir, [{:cd, ".."} | commands]), do: {:.., dir, commands}

  defp build_tree(dir, [{:cd, name} | commands]) do
    child = Enum.find(dir.children, fn c -> c.name == name end)
    children = Enum.filter(dir.children, fn c -> c.name != name end)

    case build_tree(child, commands) do
      {:.., new_dir, next_commands} ->
        build_tree(
          %ElfDir{dir | size: dir.size + new_dir.size, children: [new_dir | children]},
          next_commands
        )

      new_dir ->
        %ElfDir{dir | size: dir.size + new_dir.size, children: [new_dir | children]}
    end
  end

  defp build_tree(dir, [{:ls, response} | commands]) do
    new_dir =
      Enum.reduce(
        response,
        dir,
        fn
          {:file, filename, filesize}, acc ->
            %ElfDir{
              acc
              | size: acc.size + filesize,
                children: [%ElfFile{name: filename, size: filesize} | acc.children]
            }

          {:dir, dirname}, acc ->
            %ElfDir{acc | children: [%ElfDir{name: dirname} | acc.children]}
        end
      )

    build_tree(new_dir, commands)
  end

  defp parse_ls(<<"dir ", dir_name::binary>>), do: {:dir, dir_name}

  defp parse_ls(file) do
    [filesize, filename] = String.split(file)
    {:file, filename, String.to_integer(filesize)}
  end

  defp parse_command(<<"cd ", arg::binary>>), do: {:cd, arg}

  defp parse_command(<<"ls", arg::binary>>), do: {:ls, arg}

  defp parse_command(a), do: {:other, a}

  defp tokenize_command([command | response]) do
    command =
      command
      |> String.trim()
      |> parse_command()

    case command do
      {:ls, _} ->
        {:ls, Enum.map(response, &parse_ls/1)}

      {:cd, arg} ->
        {:cd, arg}

      _ ->
        {command}
    end
  end

  defp parse_input(input_type, input_num) do
    Files.file_for(@day, input_type, input_num)
    |> Strings.tokenize(&String.split(&1, "\n", trim: true), "$")
    |> Enum.map(&tokenize_command/1)
  end
end

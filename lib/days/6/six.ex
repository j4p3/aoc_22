defmodule Aoc22.Six do
      @moduledoc """
      Day 6: Tuning Trouble
      https://adventofcode.com/2022/day/6
      """
      alias Aoc22.Util.Files

      @day 6

      def run() do
        {one(), two()}
      end

      def one(input_type \\ :input, input_num \\ 1) do
        parse_input(input_type, input_num)
        |> packet_marker()
      end

      def two(input_type \\ :input, input_num \\ 1) do
        parse_input(input_type, input_num)
        |> som_marker()
      end

      def packet_marker(buffer), do: packet_marker(buffer, 4)

      def packet_marker(<<head::binary-1, marker::binary-3, rest::binary>>, position) do
        if MapSet.size(MapSet.new(String.to_charlist(head <> marker))) == 4 do
          position
        else
          packet_marker(<<marker::binary, rest::binary>>, position + 1)
        end
      end

      def som_marker(buffer), do: som_marker(buffer, 14)

      def som_marker(<<head::binary-1, marker::binary-13, rest::binary>>, position) do
        if MapSet.size(MapSet.new(String.to_charlist(head <> marker))) == 14 do
          position
        else
          som_marker(<<marker::binary, rest::binary>>, position + 1)
        end
      end

      defp parse_input(input_type, input_num) do
        Files.file_for(@day, input_type, input_num)
      end
    end

defmodule Aoc22.Four do
      @moduledoc """
      Day 4: Camp Cleanup
      https://adventofcode.com/2022/day/4
      """
      alias Aoc22.Util.Files
      alias Aoc22.Util.Strings

      @day 4

      def run() do
        {one(), two()}
      end

      def one(input_type \\ :input, input_num \\ 1) do
        parse_input(input_type, input_num)
        |> Enum.reduce(0, fn pairs, acc ->
          if contains?(pairs) do
            acc + 1
          else
            acc
          end
        end)
      end

      def two(input_type \\ :input, input_num \\ 1) do
        parse_input(input_type, input_num)
        |> Enum.reduce(0, fn pairs, acc ->
          if contains?(pairs) or overlaps?(pairs) do
            acc + 1
          else
            acc
          end
        end)
      end

      def contains?([[i,j],[m,n]]), do: (i >= m and j <= n) or (i <= m and j >= n)

      def overlaps?([[i,j],[m,n]]), do: (i <= m and j >= m) or (i <= n and j >= n)

      def parse_input(input_type, input_num) do
        line_tokenizer = fn line ->
          Strings.tokenize(line, fn l ->
            String.split(l, ",")
            |> Enum.map(fn pair ->
              String.split(pair, "-")
              |> Enum.map(&String.to_integer/1)
            end)
          end)
          |> then(&(Enum.at(&1, 0)))
        end

        Files.file_for(@day, input_type, input_num)
        |> Strings.tokenize(line_tokenizer)
      end
    end

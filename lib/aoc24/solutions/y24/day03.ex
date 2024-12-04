defmodule Aoc24.Solutions.Y24.Day03 do
  alias AoC.Input

  def parse(input, _part) do
    # This function will receive the input path or an %AoC.Input.TestInput{}
    # struct. To support the test you may read both types of input with either:
    #
    # * Input.stream!(input), equivalent to File.stream!/1
    # * Input.stream!(input, trim: true), equivalent to File.stream!/2
    # * Input.read!(input), equivalent to File.read!/1
    #
    # The role of your parse/2 function is to return a "problem" for the solve/2
    # function.
    #
    # For instance:
    #
    # input
    # |> Input.stream!()
    # |> Enum.map!(&my_parse_line_function/1)

    input
    |> Input.read!()
    |> String.trim()
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> String.split("mul", trim: true)
    |> tl()
    |> match()
  end

  defp match(list) do
    list
    |> Enum.filter(fn s -> String.match?(s, ~r/^\(\d+,\d+\)/) end)
    |> Enum.map(&Regex.named_captures(~r/^\((?<one>\d+),(?<two>\d+)\)/, &1))
    |> Enum.map(fn %{"one" => a, "two" => b} -> String.to_integer(a) * String.to_integer(b) end)
    |> Enum.sum()
  end

  def part_two(problem) do
    problem
    |> String.split("mul", trim: true)
    |> tl()
    |> filter()
    |> match()
  end

  defp filter(list) do
    list
    |> Enum.reduce(
      {[], true},
      fn elem, {acc, enabled?} ->
        {
          if(enabled?, do: [elem | acc], else: acc),
          check_enabled(elem, enabled?)
        }
      end
    )
    |> elem(0)
  end

  defp check_enabled(str, enabled) do
    cond do
      String.contains?(str, "do()") -> true
      String.contains?(str, "don't()") -> false
      true -> enabled
    end
  end
end

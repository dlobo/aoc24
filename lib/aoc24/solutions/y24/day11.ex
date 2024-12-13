defmodule Aoc24.Solutions.Y24.Day11 do
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
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
    |> Enum.reduce(
      %{},
      fn elem, map ->
        update_map(map, elem)
      end
    )
  end

  defp update_map(map, elem, count \\ 1) do
    Map.update(map, elem, count, fn v -> v + count end)
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> blink(75)
    |> Map.values()
    |> Enum.sum()
  end

  defp blink(result, 0), do: result

  defp blink(result, count) do
    blink(
      blink_once(result),
      count - 1
    )
  end

  defp blink_once(result) do
    result
    |> Enum.reduce(
      %{},
      fn {elem, count}, acc ->
        blink_one(acc, elem, count)
      end
    )
  end

  defp blink_one(acc, 0, count), do: update_map(acc, 1, count)

  defp blink_one(acc, number, count) do
    if number |> Integer.to_string() |> String.length() |> rem(2) == 0 do
      str = number |> Integer.to_string()
      len = String.length(str)
      {first, second} = String.split_at(str, div(len, 2))

      acc
      |> update_map(String.to_integer(first), count)
      |> update_map(String.to_integer(second), count)
    else
      update_map(acc, number * 2024, count)
    end
  end

  # def part_two(problem) do
  #   problem
  # end
end

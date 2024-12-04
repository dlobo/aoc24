defmodule Aoc24.Solutions.Y24.Day01 do
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
    |> String.split("\n")
    |> Enum.reduce(
      [[], []],
      fn line, [first, second] ->
        if line != "" do
          [a, b] =
            line
            |> String.trim()
            |> String.split()

          [[String.to_integer(a) | first], [String.to_integer(b) | second]]
        else
          [first, second]
        end
      end
    )
    |> then(fn [a, b] ->
      [
        Enum.sort(a, &(&1 >= &2)),
        Enum.sort(b, &(&1 >= &2))
      ]
    end)
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one
    problem
    |> Enum.zip()
    |> Enum.reduce(
      0,
      fn {a, b}, acc ->
        acc + abs(a - b)
      end
    )
  end

  def part_two([first, second]) do
    second = Enum.frequencies(second)

    first
    |> Enum.reduce(
      0,
      fn a, acc ->
        acc + Map.get(second, a, 0) * a
      end
    )
  end
end

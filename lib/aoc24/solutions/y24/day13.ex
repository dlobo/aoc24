defmodule Aoc24.Solutions.Y24.Day13 do
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
    |> String.split("\n\n", trim: true)
    |> Enum.reduce(
      [],
      fn machine, acc ->
        [decode(machine) | acc]
      end
    )
    |> Enum.reverse()
  end

  def decode(lines) do
    [line_a, line_b, prize] = String.split(lines, "\n", trim: true)

    line_a = explode(line_a, 10)
    line_b = explode(line_b, 10)
    prize = explode(prize, 7)
    {line_a, line_b, prize}
  end

  defp explode(str, len) do
    str
    |> String.slice(len, 1000)
    |> String.split(", ", trim: true)
    |> Enum.map(fn str -> String.slice(str, 2, 10) |> String.to_integer() end)
  end

  def part_one(_problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    nil
  end

  @total 100_000
  defp solve({a, b, prize}) do
    [ax, ay] = a
    [bx, by] = b
    [px, py] = prize
    px = px + 10_000_000_000_000
    py = py + 10_000_000_000_000

    for ai <- 0..@total,
        bi <- 0..@total,
        ai * ax + bi * bx == px and ai * ay + bi * by == py do
      ai * 3 + bi
    end
  end

  def part_two(problem) do
    problem
    |> Enum.map(&solve(&1))
    |> IO.inspect(limit: :infinity)
    |> Enum.filter(fn l -> l != [] end)
    |> Enum.map(fn l ->
      Enum.min(l)
    end)
    |> Enum.sum()
  end
end

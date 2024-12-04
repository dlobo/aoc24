defmodule Aoc24.Solutions.Y24.Day02 do
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
    |> String.split("\n")
    |> Enum.reduce(
      [],
      fn line, acc ->
        elem =
          line
          |> String.trim()
          |> String.split()
          |> Enum.map(&String.to_integer/1)

        [elem | acc]
      end
    )
    |> Enum.reverse()
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> Enum.reduce(
      0,
      fn line, acc ->
        acc + is_safe(line)
      end
    )
  end

  defp is_safe(line) do
    [[a, b] | rest] = Enum.chunk_every(line, 2, 1, :discard)

    if valid(a, b) do
      safe(rest, direction(a, b))
    else
      0
    end
  end

  defp direction(a, b) do
    if a > b do
      :desc
    else
      :asc
    end
  end

  defp valid(a, b) do
    if a != b and abs(a - b) >= 1 and abs(a - b) <= 3 do
      true
    else
      false
    end
  end

  defp safe(elems, dir) do
    elems
    |> Enum.reduce_while(
      1,
      fn [a, b], acc ->
        if valid(a, b) and direction(a, b) == dir do
          {:cont, acc}
        else
          {:halt, 0}
        end
      end
    )
  end

  def part_two(problem) do
    problem
    |> Enum.reduce(
      0,
      fn line, acc ->
        acc + safe_all(line)
      end
    )
  end

  defp safe_all(line) do
    0..length(line)
    |> Enum.reverse()
    |> Enum.reduce_while(
      0,
      fn index, acc ->
        {_elem, list} = List.pop_at(line, index)

        if is_safe(list) == 1 do
          {:halt, 1}
        else
          {:cont, acc}
        end
      end
    )
  end
end

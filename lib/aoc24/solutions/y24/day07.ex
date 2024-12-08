defmodule Aoc24.Solutions.Y24.Day07 do
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
    |> String.split("\n", trim: true)
    |> Enum.reduce(
      [],
      fn line, acc ->
        [hd, tl] = String.split(line, ":", trim: true)
        hd = String.to_integer(hd)

        tl =
          tl
          |> String.trim()
          |> String.split(" ")
          |> Enum.map(&String.to_integer/1)

        [[hd, tl] | acc]
      end
    )
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> Enum.filter(&can_find_op/1)
    |> Enum.map(&hd/1)
    |> Enum.sum()
  end

  defp can_find_op([result, values]) do
    op_combinations = length(values) - 1

    op_combinations
    |> find_all_ops()
    |> Enum.reduce_while(
      false,
      fn op_comb, acc ->
        if result == compute_result(values, op_comb) do
          {:halt, true}
        else
          {:cont, acc}
        end
      end
    )
  end

  defp with_repetitions(_list, 0), do: [[]]

  defp with_repetitions(list, k) do
    for head <- list, tail <- with_repetitions(list, k - 1), do: [head | tail]
  end

  defp find_all_ops(number) do
    ops = ["+", "*", "||"]
    with_repetitions(ops, number)
  end

  defp compute_result([hd | tl], op_comb) do
    op_comb
    |> Enum.zip(tl)
    |> Enum.reduce(
      hd,
      fn {op, value}, result ->
        case op do
          "+" -> result + value
          "||" -> (Integer.to_string(result) <> Integer.to_string(value)) |> String.to_integer()
          "*" -> result * value
          _ -> result
        end
      end
    )
  end

  def part_two(problem) do
    problem
    |> Enum.filter(&can_find_op/1)
    |> Enum.map(&hd/1)
    |> Enum.sum()
  end
end

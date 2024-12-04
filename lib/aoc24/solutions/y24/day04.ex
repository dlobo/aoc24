defmodule Aoc24.Solutions.Y24.Day04 do
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
    |> Enum.with_index()
    |> Enum.reduce(
      %{},
      fn {x, row}, map ->
        String.split(x, "", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(
          map,
          fn {val, col}, map ->
            map
            |> Map.put({row, col}, val)
            |> Map.put(:max_cols, col)
          end
        )
        |> Map.put(:max_rows, row)
      end
    )
  end

  defp find_xmas(map) do
    find_word(map, 1, 0) + find_word(map, 0, 1) + find_word(map, -1, 0) + find_word(map, 0, -1) +
      find_word(map, 1, 1) + find_word(map, -1, -1) + find_word(map, 1, -1) +
      find_word(map, -1, 1)
  end

  defp find_word(map, step_x, step_y) do
    for row <- 0..map.max_rows,
        col <- 0..map.max_cols do
      if Map.get(map, {row + 0 * step_x, col + 0 * step_y}, "") == "X" &&
           Map.get(map, {row + 1 * step_x, col + 1 * step_y}, "") == "M" &&
           Map.get(map, {row + 2 * step_x, col + 2 * step_y}, "") == "A" &&
           Map.get(map, {row + 3 * step_x, col + 3 * step_y}, "") == "S",
         do: 1,
         else: 0
    end
    |> Enum.sum()
  end

  defp find_rect(map) do
    find_fmas(map) + find_bmas(map) + find_dmas(map) + find_umas(map)
  end

  defp find_fmas(map) do
    for row <- 0..map.max_rows,
        col <- 0..map.max_cols do
      if Map.get(map, {row, col}, "") == "M" &&
           Map.get(map, {row, col + 2}, "") == "S" &&
           Map.get(map, {row + 2, col}, "") == "M" &&
           Map.get(map, {row + 2, col + 2}, "") == "S" &&
           Map.get(map, {row + 1, col + 1}, "") == "A",
         do: 1,
         else: 0
    end
    |> Enum.sum()
  end

  defp find_bmas(map) do
    for row <- 0..map.max_rows,
        col <- 0..map.max_cols do
      if Map.get(map, {row, col}, "") == "M" &&
           Map.get(map, {row, col - 2}, "") == "S" &&
           Map.get(map, {row + 2, col}, "") == "M" &&
           Map.get(map, {row + 2, col - 2}, "") == "S" &&
           Map.get(map, {row + 1, col - 1}, "") == "A",
         do: 1,
         else: 0
    end
    |> Enum.sum()
  end

  defp find_dmas(map) do
    for row <- 0..map.max_rows,
        col <- 0..map.max_cols do
      if Map.get(map, {row, col}, "") == "M" &&
           Map.get(map, {row + 2, col}, "") == "S" &&
           Map.get(map, {row, col + 2}, "") == "M" &&
           Map.get(map, {row + 2, col + 2}, "") == "S" &&
           Map.get(map, {row + 1, col + 1}, "") == "A",
         do: 1,
         else: 0
    end
    |> Enum.sum()
  end

  defp find_umas(map) do
    for row <- 0..map.max_rows,
        col <- 0..map.max_cols do
      if Map.get(map, {row, col}, "") == "M" &&
           Map.get(map, {row - 2, col}, "") == "S" &&
           Map.get(map, {row, col - 2}, "") == "M" &&
           Map.get(map, {row - 2, col - 2}, "") == "S" &&
           Map.get(map, {row - 1, col - 1}, "") == "A",
         do: 1,
         else: 0
    end
    |> Enum.sum()
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> find_xmas()
  end

  def part_two(problem) do
    problem
    |> find_rect()
  end
end

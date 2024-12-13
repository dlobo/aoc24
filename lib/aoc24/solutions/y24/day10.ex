defmodule Aoc24.Solutions.Y24.Day10 do
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
        |> Enum.map(fn v -> if v == ".", do: -1, else: String.to_integer(v) end)
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

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> Enum.filter(fn {_k, v} -> v == 0 end)
    |> Enum.map(fn {k, v} ->
      path_to_nine(k, v, problem) |> IO.inspect(label: "{#{elem(k, 0)}, #{elem(k, 1)}}")
    end)
    |> List.flatten()
    |> length()
  end

  defp path_to_nine(loc, 9, _map), do: loc

  defp path_to_nine({x, y}, value, map) do
    for pos <- neighbours({x, y}, map) do
      if Map.get(map, pos, -1) == value + 1,
        do: path_to_nine(pos, value + 1, map),
        else: []
    end
    |> List.flatten()
  end

  defp neighbours({x, y}, map) do
    mrows = map.max_rows
    mcols = map.max_cols

    []
    |> add_loc({x, y}, {1, 0}, mrows, mcols)
    |> add_loc({x, y}, {-1, 0}, mrows, mcols)
    |> add_loc({x, y}, {0, 1}, mrows, mcols)
    |> add_loc({x, y}, {0, -1}, mrows, mcols)
  end

  defp add_loc(result, {x, y}, {dx, dy}, mrows, mcols) do
    if x + dx >= 0 and x + dx <= mrows and
         y + dy >= 0 and y + dy <= mcols,
       do: [{x + dx, y + dy} | result],
       else: result
  end

  def part_two(problem) do
    problem
    |> Enum.filter(fn {_k, v} -> v == 0 end)
    |> Enum.map(fn {k, v} ->
      path_to_nine(k, v, problem)
    end)
    |> List.flatten()
    |> length()
  end
end

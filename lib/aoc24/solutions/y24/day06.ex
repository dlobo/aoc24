defmodule Aoc24.Solutions.Y24.Day06 do
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
            |> add_guard_loc(val, {row, col})
          end
        )
        |> Map.put(:max_rows, row)
      end
    )
  end

  defp add_guard_loc(map, "^", {row, col}) do
    map
    |> Map.put({row, col}, ".")
    |> Map.put(:guard_loc, {row, col})
    |> Map.put(:guard_loc_orig, {row, col})
    |> Map.put(:guard_dir, {-1, 0})
  end

  defp add_guard_loc(map, _, _), do: map

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> start_walk()
  end

  defp start_walk(map) do
    {row, col} = map.guard_loc
    {x, y} = map.guard_dir

    map = Map.put(map, {row, col}, "X")

    cond do
      Map.get(map, {row + x, col + y}, "") == "#" ->
        # this is an obstacle, we need to change direction
        map
        |> Map.put(:guard_dir, rotate({x, y}))
        |> start_walk()

      Map.get(map, {row + x, col + y}, "") in [".", "X"] ->
        map
        |> Map.put(:guard_loc, {row + x, col + y})
        |> Map.put({row + x, col + y}, "X")
        |> start_walk()

      true ->
        Enum.count(map, fn {_k, v} -> v == "X" end)
    end
  end

  defp rotate({x, y}) do
    case {x, y} do
      {0, -1} -> {-1, 0}
      {1, 0} -> {0, -1}
      {0, 1} -> {1, 0}
      {-1, 0} -> {0, 1}
    end
  end

  def part_two(problem) do
    problem
    |> mark_one()
  end

  defp mark_one(map) do
    for x <- 0..(map.max_rows + 1), y <- 0..(map.max_cols + 1) do
      if {x, y} != map.guard_loc_orig &&
           Map.get(map, {x, y}) != "#" do
        if is_infinite_loop(Map.put(map, {x, y}, "#")), do: 1, else: 0
      else
        0
      end
    end
    |> Enum.sum()
  end

  defp is_infinite_loop(map) do
    {row, col} = map.guard_loc
    {x, y} = map.guard_dir

    map =
      map
      |> Map.put({row, col}, "X")
      |> Map.update({row, col, :count}, 1, fn x -> x + 1 end)

    cond do
      Map.get(map, {row, col, :count}, 0) > 4 ->
        true

      Map.get(map, {row + x, col + y}, "") == "#" ->
        # this is an obstacle, we need to change direction
        map
        |> Map.put(:guard_dir, rotate({x, y}))
        |> is_infinite_loop()

      Map.get(map, {row + x, col + y}, "") in [".", "X"] ->
        map
        |> Map.put(:guard_loc, {row + x, col + y})
        |> is_infinite_loop()

      true ->
        false
    end
  end
end

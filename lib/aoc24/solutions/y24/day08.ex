defmodule Aoc24.Solutions.Y24.Day08 do
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
      %{antennas: %{}},
      fn {x, row}, map ->
        String.split(x, "", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(
          map,
          fn {val, col}, map ->
            map
            |> Map.put({row, col}, val)
            |> Map.put(:max_cols, col)
            |> add_antenna_loc({val, row, col})
          end
        )
        |> Map.put(:max_rows, row)
      end
    )
  end

  defp add_antenna_loc(map, {val, row, col}) do
    if val != "." do
      map.antennas
      |> Map.update(val, [{row, col}], fn v -> [{row, col} | v] end)
      |> then(fn x -> Map.put(map, :antennas, x) end)
    else
      map
    end
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    for x <- 0..problem.max_rows,
        y <- 0..problem.max_cols do
      matches(problem.antennas, {x, y})
    end
    |> Enum.filter(fn x -> x != [] end)
    |> List.flatten()
    |> Enum.uniq()
    |> length()
  end

  defp matches(antennas, {x, y}) do
    antennas
    |> Enum.reduce(
      [],
      fn {_k, locations}, acc ->
        acc ++ match(locations, {x, y})
      end
    )
  end

  defp match(locations, {x, y}) do
    locations
    |> Enum.reduce(
      [],
      fn {ax, ay}, acc ->
        dist = {2 * (ax - x), 2 * (ay - y)}

        if Enum.any?(locations, fn {lx, ly} ->
             exists({lx, ly}, {x, y}, dist)
           end) do
          [{x, y} | acc]
        else
          acc
        end
      end
    )
  end

  defp exists({lx, ly}, {x, y}, {dx, dy}) do
    x != lx && y != ly && lx - x == dx && ly - y == dy
  end

  def part_two(problem) do
    for x <- 0..problem.max_rows,
        y <- 0..problem.max_cols do
      matches(problem.antennas, {x, y})
    end
    |> Enum.filter(fn x -> x != [] end)
    |> add_antennas(problem)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
    |> IO.inspect()
    |> length()
  end

  defp add_antennas(result, map) do
    Enum.reduce(
      map.antennas,
      result,
      fn {_k, locs}, r ->
        r ++ add_antenna_lines(locs, map)
      end
    )
  end

  defp add_antenna_lines(locations, map) do
    for pt1 <- locations, pt2 <- locations do
      if pt1 == pt2 do
        [pt1]
      else
        draw_line(pt1, pt2, map)
      end
    end
  end

  defp draw_line({x1, y1}, {x2, y2}, map) do
    dx = x1 - x2
    dy = y1 - y2

    draw_op({x1, y1}, {dx, dy}, map, :add, []) ++
      draw_op({x1, y1}, {dx, dy}, map, :sub, [])
  end

  defp draw_op({x1, y1}, {dx, dy}, map, op, result) do
    if x1 < 0 or y1 < 0 or x1 > map.max_rows or y1 > map.max_cols do
      result
    else
      {new_x, new_y} = new_op({x1, y1}, {dx, dy}, op)
      draw_op({new_x, new_y}, {dx, dy}, map, op, [{x1, y1} | result])
    end
  end

  defp new_op({x1, y1}, {dx, dy}, :add), do: {x1 + dx, y1 + dy}
  defp new_op({x1, y1}, {dx, dy}, :sub), do: {x1 - dx, y1 - dy}
end

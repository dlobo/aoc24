defmodule Aoc24.Solutions.Y24.Day12 do
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
            |> Map.put({row, col}, {val, 0, 0})
            |> Map.put(:max_cols, col)
          end
        )
        |> Map.put(:max_rows, row)
      end
    )
    |> Map.update!({0, 0}, fn {val, 0, 0} -> {val, 1, 0} end)
    |> Map.put(:processed, %{})
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    problem
    |> propagate(1)
    |> compute_perimeter_area()
  end

  defp compute_perimeter_area(map) do
    map
    |> Enum.reduce(
      %{},
      fn {k, value}, acc ->
        if k in [:max_rows, :max_cols, :processed] do
          acc
        else
          {val, region, count} = value

          Map.update(acc, "#{val}-#{region}", {1, 4 - count}, fn {area, perimeter} ->
            {area + 1, perimeter + 4 - count}
          end)
        end
      end
    )
    |> Enum.reduce(
      0,
      fn {_k, {a, p}}, acc ->
        acc + a * p
      end
    )
  end

  defp propagate(map, region) do
    result =
      Enum.find(
        map,
        fn {k, value} ->
          if k in [:max_rows, :max_cols, :processed] do
            false
          else
            {_val, region, _count} = value
            if region == 0, do: true, else: false
          end
        end
      )

    if result == nil do
      map
    else
      map
      |> propagate_one(elem(result, 0), region)
      |> propagate(region + 1)
    end
  end

  defp value(map, {x, y}), do: Map.get(map, {x, y}) |> elem(0)

  defp propagate_one(map, {x, y}, region) do
    {orig, _region, count} = Map.get(map, {x, y})

    map =
      map
      |> Map.put({x, y}, {orig, region, count})
      |> Map.put(
        :processed,
        Map.put(map.processed, {x, y}, true)
      )

    map
    |> neighbours({x, y})
    |> Enum.reduce(
      map,
      fn {a, b}, map ->
        if value(map, {a, b}) == orig do
          map =
            Map.update!(
              map,
              {a, b},
              fn {orig, region, count} -> {orig, region, count + 1} end
            )

          if Map.get(map.processed, {a, b}, false) do
            map
          else
            map
            |> propagate_one({a, b}, region)
          end
        else
          map
        end
      end
    )
  end

  defp neighbours(map, {x, y}) do
    [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
    |> Enum.reduce(
      [],
      fn {dx, dy}, acc ->
        if valid(map, {x + dx, y + dy}),
          do: [{x + dx, y + dy} | acc],
          else: acc
      end
    )
  end

  defp valid(map, {x, y}) do
    if x >= 0 and x <= map.max_rows and y >= 0 and y <= map.max_cols,
      do: true,
      else: false
  end

  # def part_two(problem) do
  #   problem
  # end
end

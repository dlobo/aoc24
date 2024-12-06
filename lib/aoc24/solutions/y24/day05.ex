defmodule Aoc24.Solutions.Y24.Day05 do
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
      [%{}, %{}, []],
      fn str, [pre, post, prints] ->
        str = String.trim(str)

        if str != "" do
          if String.contains?(str, "|") do
            [first, second] = String.split(str, "|")

            [
              Map.update(pre, first, [second], fn v -> [second | v] end),
              Map.update(post, second, [first], fn v -> [first | v] end),
              prints
            ]
          else
            [
              pre,
              post,
              [String.split(str, ",") | prints]
            ]
          end
        else
          [pre, post, prints]
        end
      end
    )
  end

  def part_one(problem) do
    # This function receives the problem returned by parse/2 and must return
    # today's problem solution for part one.

    [pre, post, prints] = problem

    prints
    |> Enum.reduce(
      0,
      fn p, sum ->
        sum + check(pre, post, p)
      end
    )
  end

  defp check(pre, _post, p) do
    p
    |> Enum.reduce_while(
      [],
      fn page, seen ->
        if wrong_order(page, seen, pre) do
          {:halt, ["0"]}
        else
          {:cont, [page | seen]}
        end
      end
    )
    |> then(&middle(&1))
  end

  defp middle(li) do
    Enum.at(li, (length(li) - 1) |> div(2)) |> String.to_integer()
  end

  defp wrong_order(page, seen, pre) do
    size =
      MapSet.intersection(
        MapSet.new(seen),
        MapSet.new(Map.get(pre, page, []))
      )
      |> MapSet.size()

    if size > 0, do: true, else: false
  end

  def part_two(problem) do
    [pre, post, prints] = problem

    prints
    |> Enum.reduce(
      0,
      fn p, sum ->
        if check(pre, post, p) == 0 do
          sum + middle(hd(fix(pre, post, p)))
        else
          sum
        end
      end
    )
  end

  defp fix(pre, post, p) do
    p
    |> Enum.reduce_while(
      [[], tl(p)],
      fn page, [seen, left] ->
        if wrong_order(page, seen, pre) do
          {:halt, fix(pre, post, promote(page, seen, left))}
        else
          t = if left != [], do: tl(left), else: []
          {:cont, [[page | seen], t]}
        end
      end
    )
  end

  defp promote(page, seen, left) do
    seen = Enum.reverse(seen)
    {last, rem} = List.pop_at(seen, -1)
    rem ++ [page, last] ++ left
  end
end

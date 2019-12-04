defmodule AdventOfCode.Day03 do
  def part1(args) do
    [first, second] = init(args)

    %{}
    |> walk(first, :a)
    |> walk(second, :b)
    |> manhattan_distance()
  end

  def part2(args) do
    [first, second] = init(args)

    %{}
    |> walk(first, :a)
    |> walk(second, :b)
    |> shortest_path()
  end

  def init(args) do
    args
    |> String.split("\n", trim: true)
    |> Enum.map(fn wire -> String.split(wire, ",") end)
  end

  def walk(board, steps, name), do: do_walk(board, steps, name, {0, 0}, 0)

  def do_walk(board, [], _, _, _), do: board
  def do_walk(board, [<<direction>> <> distance | instructions], name, position, count) do
    distance = String.to_integer(distance)
    positions = for index <- 1..distance, do: {step(position, direction, index), count + index}

    board = Enum.reduce(positions, board, fn {element, index}, acc -> mark(acc, element, name, index) end)
    position = elem(List.last(positions), 0)
    do_walk(board, instructions, name, position, count + distance)
  end

  def step({x, y}, ?U, index), do: {x, y + index}
  def step({x, y}, ?D, index), do: {x, y - index}
  def step({x, y}, ?L, index), do: {x - index, y}
  def step({x, y}, ?R, index), do: {x + index, y}

  def mark(board, position, name, count) do
    case Map.get(board, position) do
      nil -> Map.put(board, position, %{name => count})
      current ->
        if Map.get(current, name) do
          board
        else
          Map.update!(board, position, fn value -> Map.put(value, name, count) end)
        end
    end
  end

  def manhattan_distance(board) do
    board
    |> Enum.filter(fn {_key, value} -> map_size(value) > 1 end)
    |> Enum.map(fn {point, _count} -> point end)
    |> Enum.map(&calculate_distance/1)
    |> Enum.sort(fn v1, v2 -> v1 < v2 end)
    |> hd()
  end

  def calculate_distance({x, y}) do
    abs(x) + abs(y)
  end

  def shortest_path(board) do
    board
    |> Enum.filter(fn {_key, value} -> map_size(value) > 1 end)
    |> Enum.map(fn {_key, value} -> value end)
    |> Enum.map(fn value -> Enum.reduce(value, 0, fn {_name, count}, acc -> acc + count end) end)
    |> Enum.sort()
    |> hd()
  end
end

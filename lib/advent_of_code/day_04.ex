defmodule AdventOfCode.Day04 do
  def part1(args) do
    [s, e] = init(args)

    generate_combinations(s, e, &valid?/1)
  end

  def part2(args) do
    [s, e] = init(args)

    generate_combinations(s, e, fn list -> valid?(list) and exactly_two?(list, {nil, 0}) end)
  end

  def init(args) do
    args
    |> String.split(["-", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def generate_combinations(s, e, pred) do
    do_generate_combinations(s, e, pred, 0)
  end

  def do_generate_combinations(s, e, _, count) when s > e, do: count

  def do_generate_combinations(s, e, pred, count) do
    digits = Integer.digits(s)

    if pred.(digits) do
      do_generate_combinations(s + 1, e, pred, count + 1)
    else
      do_generate_combinations(s + 1, e, pred, count)
    end
  end

  def valid?([a, b, c, d, e, f]) when a <= b and b <= c and c <= d and d <= e and e <= f and (a == b or b == c or c == d or d == e or e == f), do: true

  def valid?(_), do: false

  def exactly_two?([], {_, 2}), do: true
  def exactly_two?([], _), do: false
  def exactly_two?([first | _], {match, 2}) when first != match, do: true
  def exactly_two?([first | rest], {match, count}) when first == match do
    exactly_two?(rest, {match, count + 1})
  end
  def exactly_two?([first | rest], _) do
    exactly_two?(rest, {first, 1})
  end
end

defmodule AdventOfCode.Day02 do
  def part1(args) do
    args
    |> prepare()
    |> input(12, 2)
    |> evaluate()
  end

  def part2(args) do
    int_codes = prepare(args)
    combinations = for noun <- 0..99, verb <- 0..99, do: {noun, verb}
    stream = Task.async_stream(combinations, fn {noun, verb} ->
      runnable = input(int_codes, noun, verb)
      result = evaluate(runnable)
      {result, noun, verb}
    end)

    {:ok, {_, noun, verb}} = Enum.find(stream, fn {:ok, {result, _, _}} -> result == 19_690_720 end)
    100 * noun + verb
  end

  def prepare(args) do
    args
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Map.new(fn {code, index} -> {index, code} end)
  end

  def input(int_codes, noun, verb) do
    int_codes
    |> Map.put(1, noun)
    |> Map.put(2, verb)
  end

  def evaluate(int_codes), do: do_evaluate(int_codes, 0)

  def do_evaluate(int_codes, offset)
    when offset >= map_size(int_codes), do: int_codes
  def do_evaluate(int_codes, offset) do
    op_code = int_codes[offset]
    pos_a = int_codes[offset + 1]
    pos_b = int_codes[offset + 2]
    value_a = int_codes[pos_a]
    value_b = int_codes[pos_b]
    target = int_codes[offset + 3]

    case op_code do
      1 -> do_evaluate(Map.put(int_codes, target, value_a + value_b), offset + 4)
      2 -> do_evaluate(Map.put(int_codes, target, value_a * value_b), offset + 4)
      99 -> int_codes[0]
    end
  end
end

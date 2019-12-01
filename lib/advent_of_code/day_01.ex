defmodule AdventOfCode.Day01 do
  def part1(args) do
    args
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&calculate_fuel/1)
    |> Enum.sum()
  end

  def part2(args) do
    args
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(fn mass ->
      fuel = calculate_fuel(mass)
      account_for_fuel(fuel, 0)
    end)
    |> Enum.sum()
  end

  def calculate_fuel(mass) do
    floor(mass / 3) - 2
  end

  def account_for_fuel(mass, total) when mass < 1, do: total
  def account_for_fuel(mass, total) do
    account_for_fuel(calculate_fuel(mass), mass + total)
  end
end

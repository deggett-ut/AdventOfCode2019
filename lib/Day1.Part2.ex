defmodule Day1.Part2 do
  alias Day1.Part1

  @doc """
    Given an input consisting of a list of ship's masses,
    this function returns a sum total of the fuel-units
    needed.

    #Examples

      iex> Day1.Part2.process_input_list([12, 14, 1969])
      970

  """
  defdelegate process_input_list(input, fun \\ &calc_fuel/1), to: Part1

  @doc """
    Given a file with a line-seperated list of
    ship's masses, this function turns the
    input file into a list of masses and then
    calls process_input_file on that list
  """
  defdelegate process_input_file(file, funm \\ &calc_fuel/1), to: Part1

  @doc """
    The calc_fuel equation from Day 1 is modified
    to take into effect the additional weight of
    the fuel. The calc_fuel function is called
    repetedly with the fuel added until the
    Day1.calc_fuel/1 function returns either 0 or
    a negative number. These totals are then added
    together to calculate the total fuel required

    #Examples

      iex> Day1.Part2.calc_fuel(12)
      2

      iex> Day1.Part2.calc_fuel(14)
      2

      iex> Day1.Part2.calc_fuel(1969)
      966

      iex> Day1.Part2.calc_fuel(100_756)
      50346

  """
  @spec calc_fuel(mass :: non_neg_integer) :: non_neg_integer
  def calc_fuel(mass) when is_integer(mass) do
    Part1.calc_fuel(mass)
    |> Stream.iterate(&Part1.calc_fuel/1)
    |> Enum.take_while(fn x -> x > 0 end)
    |> Enum.sum()
  end
end

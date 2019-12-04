defmodule Day1.Part1 do
  @doc """
    Advent of Code 2019, Day 1
    calc_fuel calculates the number
    of units of fuel a ship will require
    based on its mass, according to the
    following formula:
    fuel = the ship's mass, divided by 3,
    rounded down to the nearest whole number,
    minus two.

    #Examples

      iex> Day1.Part1.calc_fuel(12)
      2

      iex> Day1.Part1.calc_fuel(14)
      2

      iex> Day1.Part1.calc_fuel(1969)
      654

      iex> Day1.Part1.calc_fuel(100_756)
      33583
  """

  @spec calc_fuel(mass :: non_neg_integer()) :: non_neg_integer()
  def calc_fuel(mass) when is_integer(mass) do
    # div by 3 as a float
    # force to floor -- an integer
    # and subtract two
    (((mass / 3.0)
      |> floor) - 2)

    # Finally, don't return a negative number of fuel-units
    |> max(0)
  end

  @doc """
    Given an input consisting of a list of ship's masses,
    this function returns a sum total of the fuel-units
    needed.

    #Examples

      iex> Day1.Part1.process_input_list([12, 14])
      4
  """
  @spec process_input_list(input :: nonempty_list(non_neg_integer), fun :: function()) ::
          non_neg_integer
  def process_input_list(input, fun \\ &calc_fuel/1) do
    input
    |> Stream.map(fun)
    |> Enum.sum()
  end

  @doc """
    Given a file with a line-seperated list of
    ship's masses, this function turns the
    input file into a list of masses and then
    calls process_input_file on that list
  """
  @spec process_input_file(fname :: String.t(), fun :: function()) :: non_neg_integer()
  def process_input_file(fname, fun \\ &calc_fuel/1)
      when is_binary(fname) and is_function(fun) do
    File.stream!(fname)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.map(fun)
    |> Enum.sum()
  end
end

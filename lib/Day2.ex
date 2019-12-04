defmodule Day2 do
  @doc """
  Process a list of integers as
  Intcode input.  Details on Intcode
  processing are found on the Advent
  of Code website here:

  https://adventofcode.com/2019/day/2

  #Examples

  iex> Day2.process_intcode([1, 0, 0, 3, 99])
  [1, 0, 0, 2, 99]

  iex> Day2.process_intcode([2, 0, 0, 3, 99])
  [2, 0, 0, 4, 99]

  iex> Day2.process_intcode([1, 0, 1, 2, 99])
  [1, 0, 1, 2, 99]

  iex> Day2.process_intcode([2, 2, 1, 0, 99])
  [2, 2, 1, 0, 99]

  iex> Day2.process_intcode([1,9,10,3,2,3,11,0,99,30,40,50])
  [3500,9,10,70,2,3,11,0,99,30,40,50]

  iex> Day2.process_intcode([1,1,1,4,99,5,6,0,99])
  [30,1,1,4,2,5,6,0,99]

  """
  def process_intcode(input, chunk_index \\ 0) do
    get_next_chunk(input, chunk_index)
    |> execute_chunk(input, chunk_index)
  end

  defp get_next_chunk(input, chunk_index) do
    Stream.chunk_every(input, 4)
    |> Enum.at(chunk_index)
  end

  defp execute_chunk([99 | _], input, _) do
    # the base case -- becomes the return value for process_intcode()
    input
  end

  defp execute_chunk([op, noun, verb, result_index], input, chunk_index) do
    value1 = Enum.at(input, noun)
    value2 = Enum.at(input, verb)
    result = do_action(op, value1, value2)

    input
    |> List.replace_at(result_index, result)
    # loop back to entry point with changed list
    |> process_intcode(chunk_index + 1)
  end

  defp do_action(1, v1, v2), do: v1 + v2
  defp do_action(2, v1, v2), do: v1 * v2

  def process_file(file) do
    get_intcode_list_from_file(file)
    |> process_intcode_list(12, 2)
  end

  def get_intcode_list_from_file(file) do
    file
    |> File.read!()
    |> String.split(~r/,/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def process_intcode_list(input, noun, verb) do
    input
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> Day2.process_intcode()
    |> List.first()
  end

  def find_noun_and_verb_for_solution(filename, solution) do
    input = get_intcode_list_from_file(filename)

    for n <- 0..99, v <- 0..99 do
      %{
        noun: n,
        verb: v,
        result: process_intcode_list(input, n, v)
      }
    end
    |> Enum.find(fn x -> x.result == solution end)
  end
end

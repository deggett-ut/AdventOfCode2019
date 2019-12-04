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
    Stream.chunk_every(input, 4)
    |> Enum.at(chunk_index)
    |> execute_chunk(input, chunk_index)
  end

  defp execute_chunk([99 | _], input, _) do
    input
  end

  defp execute_chunk([action, index1, index2, result_index], input, chunk_index) do
    value1 = Enum.at(input, index1)
    value2 = Enum.at(input, index2)
    result = do_action(action, value1, value2)

    input
    |> List.replace_at(result_index, result)
    |> process_intcode(chunk_index + 1)
  end

  defp do_action(1, v1, v2), do: v1 + v2
  defp do_action(2, v1, v2), do: v1 * v2

  def process_file(file) do
    get_intcode_list_from_file(file)
    |> process_list(12, 2)
  end

  def get_intcode_list_from_file(file) do
    file
    |> File.read!()
    |> String.trim()
    |> String.split(~r/,/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def process_list(input, noun, verb) do
    input
    |> List.replace_at(1, noun)
    |> List.replace_at(2, verb)
    |> Day2.process_intcode()
    |> List.first()
  end
end

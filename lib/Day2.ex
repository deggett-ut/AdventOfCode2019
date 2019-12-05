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

  @doc """
  This is the entry point for the second part of Day2. Instead of
  having a hard-codeding both filename and the number provided in the
  problem description, I'm accepting them as parameters -- along
  with an atom that specifies if I want to brute-force my way
  to the noun and verb or if I want to try my 'optimized' solution
  """
  def find_noun_and_verb_for_solution(filename, solution, approach \\ :optimized)

  def find_noun_and_verb_for_solution(filename, solution, :optimized) do
    get_intcode_list_from_file(filename)
    |> binary_search_solution(0..99, 0..99, solution)
  end

  def find_noun_and_verb_for_solution(filename, solution, :brute_force) do
    input = get_intcode_list_from_file(filename)

    for n <- 0..99, v <- 0..99, process_intcode_list(input, n, v) == solution do
      %{noun: n, verb: v}
    end
    |> List.first()
  end

  defp midpoint(%Range{} = r) do
    (r.first + r.last) |> div(2)
  end

  def binary_search_solution(
        input,
        %Range{first: first, last: last},
        %Range{} = r2,
        solution
      )
      when last - first <= 1 do
    case binary_search_solution(input, first, r2, solution) do
      :lt ->
        :lt

      :gt ->
        binary_search_solution(input, last, r2, solution)

      %{} = result ->
        result
    end
  end

  def binary_search_solution(input, %Range{} = r1, %Range{} = r2, solution) do
    mp = midpoint(r1)

    case binary_search_solution(input, mp, r2, solution) do
      :lt ->
        binary_search_solution(input, %Range{first: mp, last: r1.last}, r2, solution)

      :gt ->
        binary_search_solution(input, %Range{first: r1.first, last: mp}, r2, solution)

      %{} = result ->
        result
    end
  end

  def binary_search_solution(input, noun, %Range{first: first, last: last}, solution)
      when is_integer(noun) and last - first <= 1 do
    case binary_search_solution(input, noun, first, solution) do
      :lt ->
        binary_search_solution(input, noun, last, solution)

      :gt ->
        :gt

      %{} = result ->
        result
    end
  end

  def binary_search_solution(input, noun, %Range{} = r2, solution) do
    mp = midpoint(r2)

    case binary_search_solution(input, noun, mp, solution) do
      :lt ->
        binary_search_solution(input, noun, %Range{first: mp, last: r2.last}, solution)

      :gt ->
        binary_search_solution(input, noun, %Range{first: r2.first, last: mp}, solution)

      %{} = result ->
        result
    end
  end

  def binary_search_solution(input, noun, verb, solution) do
    case process_intcode_list(input, noun, verb) do
      x when x < solution ->
        :lt

      x when x > solution ->
        :gt

      x when x == solution ->
        %{noun: noun, verb: verb}
    end
  end
end

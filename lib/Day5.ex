defmodule Day5 do
  @doc """
  Process a list of integers as
  Intcode input.  Details on Intcode
  processing are found on the Advent
  of Code website here:

  https://adventofcode.com/2019/day/2

  #Examples

  iex> Day5.process_intcode([1, 0, 0, 3, 99])
  [1, 0, 0, 2, 99]

  iex> Day5.process_intcode([2, 0, 0, 3, 99])
  [2, 0, 0, 4, 99]

  iex> Day5.process_intcode([1, 0, 1, 2, 99])
  [1, 0, 1, 2, 99]

  iex> Day5.process_intcode([2, 2, 1, 0, 99])
  [2, 2, 1, 0, 99]

  iex> Day5.process_intcode([1,9,10,3,2,3,11,0,99,30,40,50])
  [3500,9,10,70,2,3,11,0,99,30,40,50]

  iex> Day5.process_intcode([1,1,1,4,99,5,6,0,99])
  [30,1,1,4,2,5,6,0,99]

  """
  def process_intcode(input, chunk_index \\ 0) do
    get_next_chunk(input, chunk_index)
    |> execute_chunk(input, chunk_index)
  end

  defp get_next_chunk(input, chunk_index) do
    Enum.drop(input, chunk_index)
  end

  # converts a 0 or 1 from the mode digets
  # in an opcode into atoms representing
  # positional or immediate modes
  defp op_mode(0), do: :pos
  defp op_mode(1), do: :imm

  defp process_opcode(raw_opcode) when raw_opcode < 100,
    do: {{:pos, :pos, :pos}, raw_opcode}

  defp process_opcode(raw_opcode) when is_integer(raw_opcode),
    do: process_opcode(Integer.digits(raw_opcode))

  defp process_opcode([op, r1, r2]) do
    {{:pos, :pos, op_mode(op)}, Integer.undigits([r1, r2])}
  end

  defp process_opcode([op1, op2, r1, r2]) do
    {{:pos, op_mode(op1), op_mode(op2)}, Integer.undigits([r1, r2])}
  end

  defp process_opcode([op1, op2, op3, r1, r2]) do
    {{op_mode(op1), op_mode(op2), op_mode(op3)}, Integer.undigits([r1, r2])}
  end

  defp fetch_value(:pos, index, input), do: Enum.at(input, index)
  defp fetch_value(:imm, val, _), do: val

  defp execute_chunk([raw_opcode | tail], input, chunk_index) do
    {modes, processed_opcode} = process_opcode(raw_opcode)
    execute_chunk(modes, [processed_opcode | tail], input, chunk_index)
  end

  defp execute_chunk(_, [99 | _], input, _) do
    # the base case -- becomes the return value for process_intcode()
    input
  end

  defp execute_chunk({_mode3, mode2, mode1}, [op, p1, p2, p3 | _], input, chunk_index)
       when op == 1 or op == 2 do
    noun = fetch_value(mode1, p1, input)
    verb = fetch_value(mode2, p2, input)
    result_index = p3
    result = do_action(op, noun, verb)

    input
    |> List.replace_at(result_index, result)
    |> process_intcode(chunk_index + 4)
  end

  defp execute_chunk({_, _, _}, [3, idx | _], input, chunk_index) do
    input
    |> List.replace_at(idx, get_next_input())
    |> process_intcode(chunk_index + 2)
  end

  defp execute_chunk({_, _, _}, [4, idx | _], input, chunk_index) do
    input
    |> Enum.at(idx)
    |> handle_output

    process_intcode(input, chunk_index + 2)
  end

  defp execute_chunk({_, _, _}, [cmd, _idx | _], input, chunk_index)
       when cmd > 4 do
    process_intcode(input, chunk_index + 2)
  end

  defp get_next_input do
    # For the Day5 puzzle, the
    # only input request gets a 1
    1
  end

  defp handle_output(val) do
    IO.puts("Output: #{val}")
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
    |> process_intcode()
    |> List.first()
  end
end

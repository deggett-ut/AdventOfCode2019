defmodule Day3.WireCreator do
  @doc """
  turns a list of strings representing wires
  into a list of lists of wire segments for
  use later in the main program.

  Examples#
    iex> Day3.WireCreator.turn_text_lines_into_wires(["U2,L2", "R2,D2"])
    [[{:up, 2}, {:left, 2}], [{:right, 2}, {:down, 2}]]
  """
  @spec turn_text_lines_into_wires(text_lines :: list(String.t())) :: list(list({atom, integer}))
  def turn_text_lines_into_wires(text_lines) do
    text_lines
    |> Enum.map(&extract_wire/1)
  end

  @doc """
  extract_wire takes a string representing a wire
  and converts it into the representation that
  will be iterated for the other parts of the
  puzzle.

  Examples#
    iex> Day3.WireCreator.extract_wire("D32,R10")
    [{:down, 32}, {:right, 10}]

    iex> Day3.WireCreator.extract_wire("U4,L1042")
    [{:up, 4}, {:left, 1042}]
  """
  @spec extract_wire(wire_description :: String.t()) :: list({atom(), integer()})
  def extract_wire(wire_description) do
    String.split(wire_description, ~r/,/, trim: true)
    |> Enum.map(&convert_wire_description_segment/1)
  end

  @char_direction_map %{
    ?U => :up,
    ?D => :down,
    ?R => :right,
    ?L => :left
  }

  @doc """
  convert_wire_description_segment takes a string
  containing the direction and the number of units
  in that direction and returns a tuple of the
  direction atom and the integer representation
  for the units moved.

  Examples#
    iex> Day3.WireCreator.convert_wire_description_segment("U32")
    {:up, 32}

    iex> Day3.WireCreator.convert_wire_description_segment("D45")
    {:down, 45}

    iex> Day3.WireCreator.convert_wire_description_segment("R2")
    {:right, 2}

    iex> Day3.WireCreator.convert_wire_description_segment("L765")
    {:left, 765}
  """
  @spec convert_wire_description_segment(segment_description :: String.t()) :: {atom(), integer()}
  def convert_wire_description_segment(<<dir::size(8), move_count::binary>>) do
    {@char_direction_map[dir], String.to_integer(move_count)}
  end
end

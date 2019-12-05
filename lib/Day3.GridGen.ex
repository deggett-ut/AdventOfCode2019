defmodule Day3.GridGen do
  @doc """
  Given a set of 'wires'
  (lists of {atom, integer} pairs),
  generate the extents of the grid that
  will contain those wires.

  Examples#
    iex> Day3.GridGen.get_grid_extents_from_wires([[{:up, 2}], [{:right, 2}]])
    %{horizontal: 0..2, vertical: 0..2}
  """
  @spec get_grid_extents_from_wires(wires :: list(list({atom, integer}))) :: %{
          horizontal: Range.t(),
          vertical: Range.t()
        }
  def get_grid_extents_from_wires(wires) do
    wires
    |> Enum.map(&calculate_wire_extents/1)
    |> Enum.reduce(fn %{} = grid1, %{} = grid2 ->
      %{
        horizontal: merge_ranges(grid1.horizontal, grid2.horizontal),
        vertical: merge_ranges(grid1.vertical, grid2.vertical)
      }
    end)
  end

  @doc """
    merges two ranges together

    Examples#
      iex> Day3.GridGen.merge_ranges(0..2, 1..3)
      0..3

      iex> Day3.GridGen.merge_ranges(5..10, 7..9)
      5..10

      iex> Day3.GridGen.merge_ranges(5..15, 3..12)
      3..15
  """
  @spec merge_ranges(Range.t(), Range.t()) :: Range.t()
  def merge_ranges(range1, first..last) do
    range1
    |> expand_range(first)
    |> expand_range(last)
  end

  @doc """
    calculate_wire_extents takes a description of
    a wire, which is a list of atom, integer pairs
    and, assuming the starting point is at (0, 0),
    it will calculate the horizontal and vertical
    extents of the grid which will contain the
    entirety of the wire

    Examples#
      iex> Day3.GridGen.calculate_wire_extents([{:up, 3}, {:right, 3}])
      %{horizontal: 0..3, vertical: 0..3}
  """
  @spec calculate_wire_extents(wire_description :: [{atom, integer}]) ::
          %{horizontal: %Range{}, vertical: %Range{}}
  def calculate_wire_extents(wire_description) do
    [_, h_range, v_range] =
      wire_description
      |> Enum.reduce(
        [%{x: 0, y: 0}, 0..0, 0..0],
        fn segment, [position, h_range, v_range] ->
          new_pos = apply_segment(position, segment)

          [
            new_pos,
            expand_range(h_range, new_pos.x),
            expand_range(v_range, new_pos.y)
          ]
        end
      )

    %{horizontal: h_range, vertical: v_range}
  end

  @doc """
  apply_segment applies a wire segment to a grid
  position to generate a new grid position

  Examples#
    iex> Day3.GridGen.apply_segment(%{x: 0, y: 0}, {:up, 3})
    %{x: 0, y: 3}

    iex> Day3.GridGen.apply_segment(%{x: 0, y: 3}, {:right, 5})
    %{x: 5, y: 3}

    iex> Day3.GridGen.apply_segment(%{x: 5, y: 3}, {:down, 10})
    %{x: 5, y: -7}

    iex> Day3.GridGen.apply_segment(%{x: 5, y: -7}, {:left, 15})
    %{x: -10, y: -7}
  """

  @spec apply_segment(%{x: integer(), y: integer()}, {atom, integer}) ::
          %{x: integer, y: integer}
  def apply_segment(%{} = pos, {:up, steps}), do: %{pos | y: pos.y + steps}
  def apply_segment(%{} = pos, {:down, steps}), do: %{pos | y: pos.y - steps}
  def apply_segment(%{} = pos, {:right, steps}), do: %{pos | x: pos.x + steps}
  def apply_segment(%{} = pos, {:left, steps}), do: %{pos | x: pos.x - steps}

  @doc """
    expand_range takes and integer and a range
    and returns either a new range that
    includes the integer (if it was outside
    of the range) or the original range (if
    the integer was already included in it)

    Examples#
      iex> Day3.GridGen.expand_range(-2..2, 0)
      -2..2

      iex> Day3.GridGen.expand_range(-2..2, 5)
      -2..5

      iex> Day3.GridGen.expand_range(-2..5, -8)
      -8..5
  """
  @spec expand_range(Range.t(), integer) :: Range.t()
  def expand_range(first..last, pos) do
    min(pos, first)..max(pos, last)
  end

  @doc """
    Given a map containing horizontal and vertical
    ranges, generates a map with horiz x vert dimensions
    using tuples with x, y coordinates as the keys.
    When this function exits, the values for every
    key will all be set to {false, false}

    Examples#
      iex> Day3.GridGen.convert_extents_into_grid_map(
      ...> %{horizontal: 0..1, vertical: 0..1})
      %{{0, 0} => {false, false}, {0, 1} => {false, false},
        {1, 0} => {false, false}, {1, 1} => {false, false}}
  """
  @spec convert_extents_into_grid_map(%{horizontal: Range.t(), vertical: Range.t()}) :: map
  def convert_extents_into_grid_map(%{horizontal: h_range, vertical: v_range}) do
    for x <- h_range, y <- v_range, into: %{} do
      {{x, y}, {false, false}}
    end
  end
end

defmodule Day3.Grid do
  @spec place_wires_on_grid([[{atom, integer}]]) :: map
  def place_wires_on_grid(wires) do
    # tuple of wire segments with their respective index
    Enum.with_index(wires)
    |> Enum.reduce(
      # our base-accumulator: a tuple with position and the
      # grid (map) we're going to populate
      %{},
      fn {segment_list, wire_index}, grid ->
        apply_wire_to_grid(segment_list, grid, wire_index)
      end
    )
  end

  @doc """
    adding a wire to the grid is done by recursively applying
    the segments of the wire (the segment_list). The 3rd
    parameter, wire_index, is used by the apply_wire_segment
    function to turn on the value in the grid representing
    the current wire.
  """
  def apply_wire_to_grid(segment_list, grid, wire_index) do
    {_end_Position, pop_grid, _} =
      Enum.reduce(
        segment_list,
        # starting position (the origin),
        # the grid, and the number of steps
        # the wire uses to get to the grid point
        # we're populating are the accumulators
        {{0, 0}, grid, 1},
        fn {direction, length}, {pos, inner_grid, steps_taken} ->
          apply_wire_segment_to_grid(inner_grid, pos, direction, length, wire_index, steps_taken)
        end
      )

    pop_grid
  end

  @doc """
    apply_wire_segment_to_grid is a recursive loop function
    that decrements the wire's length until it's 0. Once
    the entire wire segment has been applied, apply_wire_segment
    returns a tuple with the last position of the wire and
    the updated grid with the wire path for this segment marked
  """
  def apply_wire_segment_to_grid(%{} = grid, pos, _, 0, _, steps_taken),
    do: {pos, grid, steps_taken}

  def apply_wire_segment_to_grid(grid, pos, dir, length, wire_index, steps_taken) do
    new_pos = get_new_position(pos, dir)

    apply_wire_segment_to_grid(
      Map.update(
        grid,
        new_pos,
        update_tuple({0, 0}, wire_index, steps_taken),
        &update_tuple(&1, wire_index, steps_taken)
      ),
      new_pos,
      dir,
      length - 1,
      wire_index,
      steps_taken + 1
    )
  end

  def update_tuple({_, _} = v, wire_index, steps_taken) do
    put_elem(v, wire_index, steps_taken)
  end

  @spec get_new_position({integer, integer}, :down | :left | :right | :up) :: {integer, integer}
  def get_new_position({x, y}, :up), do: {x, y + 1}
  def get_new_position({x, y}, :down), do: {x, y - 1}
  def get_new_position({x, y}, :left), do: {x - 1, y}
  def get_new_position({x, y}, :right), do: {x + 1, y}

  @doc """
  Finds the closest intersection point to the
  origin based on calculating the manattan-distance
  """
  def find_closest_intersection_point(grid) do
    find_intersection_points(grid)
    |> Enum.map(fn {k, _v} -> k end)
    |> Enum.sort(&manhattan_compare/2)
    |> List.first()
  end

  @doc """
  Finds the closest intersection point to the
  origin based on calculating the manattan-distance
  """
  def find_intersection_point_by_steps_taken(grid) do
    {_k, {steps1, steps2}} =
      find_intersection_points(grid)
      |> Enum.sort(&step_compare/2)
      |> List.first()

    steps1 + steps2
  end

  @spec manhattan_distance({number, number}) :: number
  defp manhattan_distance({x, y}), do: abs(x) + abs(y)

  @spec manhattan_compare({number, number}, {number, number}) :: boolean
  defp manhattan_compare(v1, v2) do
    manhattan_distance(v1) < manhattan_distance(v2)
  end

  defp step_compare({_k1, {wire1_steps1, wire2_steps1}}, {_k2, {wire1_steps2, wire2_steps2}}) do
    wire1_steps1 + wire2_steps1 < wire1_steps2 + wire2_steps2
  end

  @doc """
    Given a populated grid, like the output
    of place_wires_on_grid, this function
    finds the locations on the grid
    populated by multiple wires
  """
  def find_intersection_points(grid) do
    grid
    |> Enum.filter(fn
      {_, {wire_0_steps, wire_1_steps}}
      when wire_0_steps > 0 and wire_1_steps > 0 ->
        true

      _ ->
        false
    end)
  end
end

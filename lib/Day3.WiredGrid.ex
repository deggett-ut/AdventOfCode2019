defmodule Day3.WiredGrid do
  def place_wires_on_grid(wires, grid) do
    Enum.reduce(
      wires,
      {%{x: 0, y: 0}, grid, 0},
      fn {direction, length}, {pos, grid, wire_index} ->
        grid
        |> apply_wire_to_grid(pos, direction, length, wire_index)
      end
    )
  end

  @spec apply_wire_to_grid(map, map, atom, non_neg_integer, any) :: map
  def apply_wire_to_grid(%{} = grid, _pos, _, 0, _), do: grid

  def apply_wire_to_grid(grid, pos, dir, length, wire_index) do
    new_pos = get_new_position(pos, dir)
    new_value = put_elem(grid[new_pos], wire_index, true)

    apply_wire_to_grid(
      Map.replace!(grid, new_pos, new_value),
      new_pos,
      dir,
      length - 1,
      wire_index
    )
  end

  @spec get_new_position(map, :down | :left | :right | :up) :: map
  def get_new_position(%{} = pos, :up), do: %{pos | y: pos.y + 1}
  def get_new_position(%{} = pos, :down), do: %{pos | y: pos.y - 1}
  def get_new_position(%{} = pos, :left), do: %{pos | x: pos.x - 1}
  def get_new_position(%{} = pos, :right), do: %{pos | x: pos.x + 1}
end

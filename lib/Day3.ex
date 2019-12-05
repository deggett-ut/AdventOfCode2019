defmodule Day3 do
  alias Day3.WireGen
  alias Day3.GridGen

  @input_file Path.join("test", "Day3-input.txt")

  def process_input_file(file_name \\ @input_file) do
    wires =
      file_name
      |> break_file_into_lines()
      |> WireGen.turn_text_lines_into_wires()

    %{horizontal: h_range, vertical: v_range} =
      wires
      |> GridGen.get_grid_extents_from_wires()
      |> GridGen.convert_extents_into_grid_map()

    for x <- h_range, y <- v_range, into: %{} do
      %{x: x, y: y}
    end
  end

  def break_file_into_lines(file_name) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end
end

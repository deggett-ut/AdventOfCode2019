defmodule Day3 do
  alias Day3.WireCreator
  alias Day3.Grid.Part1, as: Grid

  @input_file Path.join("test", "Day3-input.txt")

  def process_input_file(file_name \\ @input_file) do
    file_name
    |> break_file_into_lines()
    |> WireCreator.turn_text_lines_into_wires()
    |> Grid.place_wires_on_grid()
    |> Grid.find_closest_intersection_point()
  end

  def break_file_into_lines(file_name) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end
end

defmodule Day3 do
  alias Day3.WireCreator
  alias Day3.Grid, as: Grid

  @input_file Path.join("test", "Day3-input.txt")

  def process_input_file(file_name \\ @input_file, algorithm \\ :steps) do
    file_name
    |> break_file_into_lines()
    |> WireCreator.turn_text_lines_into_wires()
    |> Grid.place_wires_on_grid()
    |> (fn x ->
          case algorithm do
            :manhattan -> Grid.find_closest_intersection_point(x)
            :steps -> Grid.find_intersection_point_by_steps_taken(x)
          end
        end).()
  end

  def break_file_into_lines(file_name) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Enum.to_list()
  end
end

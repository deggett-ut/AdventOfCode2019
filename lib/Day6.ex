defmodule Day6 do
  # @input_file Path.join("test", "Day6-input.txt")
  @input_file Path.join("test", "Day6-input.txt")

  def build_orbit_map_from_file(file_name \\ @input_file) do
    File.stream!(file_name)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ")", trim: true, parts: 2))
    |> Enum.reduce(%{}, fn [center, orbiting], orbit_store ->
      Map.update(orbit_store, center, [orbiting], fn orbits -> [orbiting | orbits] end)
    end)
  end

  def count_orbits_for_center_pt(orbit_map, center, depth \\ 0) do
    case Map.fetch(orbit_map, center) do
      {:ok, orbits} ->
        depth + Enum.sum(Enum.map(orbits, &count_orbits_for_center_pt(orbit_map, &1, depth + 1)))

      :error ->
        depth
    end
  end

  def count_all_orbits(orbit_map) do
    Map.keys(orbit_map)
    |> Enum.map(&count_orbits_for_center_pt(orbit_map, &1))
    |> Enum.sum()
  end
end

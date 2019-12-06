defmodule Day4 do
  @input_range 168_630..718_098

  def count_valid_passwords(input \\ @input_range) do
    for x <- input, valid_password?(x), into: [] do
      x
    end
    |> Enum.count()
  end

  def valid_password?(attempt) do
    attempt_as_list = pre_process_attempt_to_sorted_list(attempt)

    right_length?(attempt_as_list) &&
      adjacent_digits_duplicated?(attempt_as_list) &&
      same_number_when_sorted?(attempt, attempt_as_list) &&
      one_duplicated_number?(attempt_as_list)
  end

  def one_duplicated_number?(attempt_as_list) do
    Enum.reduce(attempt_as_list, %{}, fn x, acc ->
      Map.update(acc, x, 1, &(&1 + 1))
      |> Enum.any?(fn {_digit, digit_count} ->
        digit_count == 2
      end)
    end)
  end

  def same_number_when_sorted?(attempt, attempt_as_list) do
    sorted_list_as_number(attempt_as_list) == attempt
  end

  def right_length?(attempt_as_list) do
    Enum.count(attempt_as_list) == 6
  end

  def adjacent_digits_duplicated?(attempt_as_list) do
    Enum.count(attempt_as_list) >
      remove_duplicates(attempt_as_list)
      |> Enum.count()
  end

  def remove_duplicates(attempt_as_list) do
    attempt_as_list
    |> Enum.uniq()
  end

  def pre_process_attempt_to_sorted_list(attempt) do
    attempt
    |> Integer.digits()
  end

  def sorted_list_as_number(attempt_as_list) do
    attempt_as_list
    |> Enum.sort()
    |> Integer.undigits()
  end
end

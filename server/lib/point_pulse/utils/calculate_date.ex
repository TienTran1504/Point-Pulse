defmodule PointPulse.Utils.CalculateDate do
  def week_to_month_with_working_days(date_str) do
    date_of_week = _week_to_month(date_str)
    day_of_week = Date.day_of_week(date_of_week)
    first_day_of_week = Date.add(date_of_week, -day_of_week + 1)
    calculate_date = Date.add(first_day_of_week, 2)
    {year, month, day} = Date.to_erl(first_day_of_week)
    {calculate_year, calculate_month, calculate_day} = Date.to_erl(calculate_date)

    if month == calculate_month do
      week_of_year = _week_of_year(%{year: year, month: month, day: day})

      %{
        week: week_of_year,
        year: year,
        month: month
      }
    else
      week_of_year =
        _week_of_year(%{year: calculate_year, month: calculate_month, day: calculate_day})

      %{
        week: week_of_year,
        year: calculate_year,
        month: calculate_month
      }
    end
  end

  defp _week_of_year(%{year: year, month: month, day: day}) do
    {:ok, first_day_of_year} = Date.new(year, 1, 1)
    {:ok, current_day} = Date.new(year, month, day)
    day_of_week = Date.day_of_week(first_day_of_year)

    first_day_of_year = Date.add(first_day_of_year, 1 - day_of_week)
    day_diff = Date.diff(current_day, first_day_of_year)
    week_number = div(day_diff, 7) + 1

    week_number
  end

  defp _week_to_month(date_str) do
    # Parse the date string in the format "DD-MM-YYYY"
    [year, month, day] = String.split(date_str, "-") |> Enum.map(&String.to_integer/1)
    # Convert the date components to a Date object
    {:ok, date} = Date.new(year, month, day)
    date
  end

  def get_dates_in_range(start_date_str, end_date_str) do
    {:ok, start_date} = Date.from_iso8601(start_date_str)
    {:ok, end_date} = Date.from_iso8601(end_date_str)

    # Tính toán số ngày giữa start và end
    days_between = (Date.diff(end_date, start_date) / 7) |> round()

    # Tạo danh sách các chuỗi ngày nằm trong khoảng với khoảng cách interval_days
    Enum.reduce_while(0..days_between, [], fn day_offset, acc ->
      current_date = Date.add(start_date, day_offset * 7)
      new_end_date = Date.add(end_date, 1)

      if Date.before?(current_date, new_end_date) do
        {:cont, [current_date |> Date.to_string() | acc]}
      else
        {:cont, [end_date |> Date.to_string() | acc]}
      end
    end)
    |> Enum.reverse()
  end
end

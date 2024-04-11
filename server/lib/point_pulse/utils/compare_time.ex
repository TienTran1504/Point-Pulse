defmodule PointPulse.Utils.CompareTime do
  defp _compare_week(current_week, input_week) do
    case _compare_field(current_week, input_week) do
      :lt -> false
      :eq -> true
      :gt -> true
    end
  end

  defp _compare_field(value1, value2) do
    cond do
      value1 < value2 -> :lt
      value1 > value2 -> :gt
      true -> :eq
    end
  end

  def is_lt?(
        %{year: current_year, week: current_week, month: _current_month} = _current_time,
        %{year: input_year, week: input_week, month: _input_month} = _week_input
      ) do
    case _compare_field(current_year, input_year) do
      :lt -> false
      :eq -> _compare_week(current_week, input_week)
      :gt -> true
    end
  end

  def is_lt?(%{} = _current_time, %{} = _week_input) do
    false
  end

  def is_lt?(
        %{year: _current_year, week: _current_week, month: _current_month} = _current_time,
        %{} = _week_input
      ) do
    false
  end

  def is_lt?(
        %{} = _current_time,
        %{year: _input_year, week: _input_week, month: _input_month} = _week_input
      ) do
    false
  end
end

defmodule PointPulseWeb.Time.GetWeekOfYearJSON do
  def show(%{week_infor: week_infor}) do
    %{
      status: :OK,
      data: %{year: week_infor.year, week_of_year: week_infor.week, month: week_infor.month}
    }
  end
end

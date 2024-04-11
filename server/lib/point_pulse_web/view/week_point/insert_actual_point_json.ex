defmodule PointPulseWeb.UserWeekPoint.InsertActualPointJSON do
  alias PointPulse.UserWeekPoints.UserWeekPoint

  def show(%{user_week_point: user_week_point}) do
    %{status: :OK, data: data(user_week_point)}
  end

  def show_warning(%{infor_point: infor_point}) do
    %{status: :error, error_code: 1001, data: data_warning(infor_point)}
  end

  def show_message(%{message: message}) do
    %{status: :BAD_REQUEST, message: message}
  end

  defp data(%UserWeekPoint{} = user_week_point) do
    %{
      id: user_week_point.id,
      project_id: user_week_point.project_id,
      user_id: user_week_point.user_id,
      year: user_week_point.year,
      week_of_year: user_week_point.week_of_year,
      month: user_week_point.month,
      plan_point: user_week_point.plan_point,
      actual_point: user_week_point.actual_point
    }
  end

  defp data_warning(infor_point) do
    %{
      project_id: infor_point.project_id,
      user_id: infor_point.user_id,
      year: infor_point.year,
      week_of_year: infor_point.week_of_year,
      plan_point: infor_point.plan_point,
      actual_point: infor_point.actual_point,
      new_actual_point: infor_point.new_actual_point
    }
  end
end

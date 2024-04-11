defmodule PointPulseWeb.UserWeekPoint.UpdateUserWeekPointJSON do
  alias PointPulse.UserWeekPoints.UserWeekPoint

  def show(%{user_week_point: user_week_point}) do
    %{status: :OK, data: data(user_week_point)}
  end

  def show_message(%{message: message}) do
    %{status: :BAD_REQUEST, message: message}
  end

  def show_updated_user_week_point(%{user_week_point: user_week_point}) do
    %{status: :OK, data: data(user_week_point)}
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
      actual_point: user_week_point.actual_point,
      inserted_at: user_week_point.inserted_at,
      updated_at: user_week_point.updated_at,
      inserted_by: user_week_point.inserted_by,
      updated_by: user_week_point.updated_by
    }
  end
end

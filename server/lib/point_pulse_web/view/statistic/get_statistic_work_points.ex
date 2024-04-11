defmodule PointPulseWeb.Statistic.GetStatisticWorkPointsJSON do
  alias PointPulse.UserWeekPoints.UserWeekPoint

  def show(%{user_week_point: user_week_point}) do
    %{status: :OK, data: data(user_week_point)}
  end

  def show_list(%{user_week_points: user_week_points}) do
    %{status: :OK, data: for(user_week_point <- user_week_points, do: data(user_week_point))}
  end

  def show_work_points(%{data: data}) do
    %{status: :OK, data: for(point <- data, do: data_point(point))}
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

  defp data_point(point) do
    %{
      user_id: point.user_id,
      name: point.name,
      start_time: point.start_time,
      end_time: point.end_time,
      plan_point: point.plan_point,
      work_point: point.work_point,
      remaining: point.remaining,
    }
  end
end

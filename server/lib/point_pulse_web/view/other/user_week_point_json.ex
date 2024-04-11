defmodule PointPulseWeb.UserWeekPointJSON do
  alias PointPulse.UserWeekPoints.UserWeekPoint

  @doc """
  Renders a list of user_week_points.
  """
  def index(%{user_week_points: user_week_points}) do
    %{data: for(user_week_point <- user_week_points, do: data(user_week_point))}
  end

  @doc """
  Renders a single user_week_point.
  """
  def show(%{user_week_point: user_week_point}) do
    %{data: data(user_week_point)}
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
      inserted_by: user_week_point.inserted_by,
      updated_by: user_week_point.updated_by
    }
  end
end

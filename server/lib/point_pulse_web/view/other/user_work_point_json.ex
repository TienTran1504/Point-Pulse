defmodule PointPulseWeb.UserWorkPointJSON do
  alias PointPulse.UserWorkPoints.UserWorkPoint

  @doc """
  Renders a list of user_work_points.
  """
  def index(%{user_work_points: user_work_points}) do
    %{data: for(user_work_point <- user_work_points, do: data(user_work_point))}
  end

  @doc """
  Renders a single user_work_point.
  """
  def show(%{user_work_point: user_work_point}) do
    %{data: data(user_work_point)}
  end

  defp data(%UserWorkPoint{} = user_work_point) do
    %{
      id: user_work_point.id,
      user_id: user_work_point.user_id,
      year: user_work_point.year,
      week_of_year: user_work_point.week_of_year,
      month: user_work_point.month,
      work_point: user_work_point.work_point,
      inserted_by: user_work_point.inserted_by,
      updated_by: user_work_point.updated_by
    }
  end
end

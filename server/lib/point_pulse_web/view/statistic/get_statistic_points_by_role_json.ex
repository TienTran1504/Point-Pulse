defmodule PointPulseWeb.Statistic.GetStatisticPointsByRoleJSON do
  alias PointPulse.UserWeekPoints.UserWeekPoint

  def show(%{user_week_point: user_week_point}) do
    %{status: :OK, data: data(user_week_point)}
  end

  def show_list(%{user_week_points: user_week_points}) do
    %{status: :OK, data: for(user_week_point <- user_week_points, do: data(user_week_point))}
  end

  def statistic_roles(%{data: list_roles_point}) do
    %{
      status: :OK,
      data: for(role_point <- list_roles_point, do: data_role(role_point))
    }
  end

  defp data_role(infor) do
    %{
      start_date: infor.start_date,
      end_date: infor.end_date,
      project: infor.project,
      plan_point: infor.plan_point,
      actual_point: infor.actual_point,
      data_role: infor.data_role
    }
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

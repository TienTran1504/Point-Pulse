defmodule PointPulseWeb.Project.GetProjectJSON do
  alias PointPulse.Projects.Project
  alias PointPulse.UserWeekPoints.UserWeekPoint

  def show(%{
        project: project,
        actual_point: actual_point,
        plan_point: plan_point,
        week_points: week_points
      }) do
    %{
      status: :OK,
      data: %{
        project: data(project, actual_point, plan_point),
        week_points: for(week_point <- week_points, do: data_week_point(week_point))
      }
    }
  end

  def show_list(%{projects: projects}) do
    %{status: :OK, data: for(project <- projects, do: data_list(project))}
  end

  defp data(%Project{} = project, actual_point, plan_point) do
    %{
      id: project.id,
      name: project.name,
      type_id: project.type_id,
      locked: project.locked,
      project_type: project.project_type.name,
      actual_point: actual_point,
      plan_point: plan_point,
      start_date: project.start_date,
      end_date: project.end_date,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at,
      deleted_at: project.deleted_at,
      inserted_by: project.inserted_by,
      updated_by: project.updated_by
    }
  end

  defp data_week_point(%UserWeekPoint{} = user_week_point) do
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

  defp data_list(%Project{} = project) do
    %{
      id: project.id,
      name: project.name,
      type_id: project.type_id,
      locked: project.locked,
      project_type: project.project_type.name,
      start_date: project.start_date,
      end_date: project.end_date,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at,
      deleted_at: project.deleted_at,
      inserted_by: project.inserted_by,
      updated_by: project.updated_by
    }
  end
end

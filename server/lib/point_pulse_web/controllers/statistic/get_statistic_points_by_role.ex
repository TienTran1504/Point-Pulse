defmodule PointPulseWeb.Statistic.GetStatisticPointsByRoleController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.Projects
  alias PointPulse.ProjectUsers
  alias PointPulse.Utils.CalculateDate
  action_fallback(PointPulseWeb.FallbackController)

  @api_param_get_points_by_role %{
    start_time: [
      type: :string,
      required: true
    ],
    end_time: [
      type: :string,
      required: true
    ]
  }
  def show_projects_role_points(conn, params) do
    params =
      @api_param_get_points_by_role
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    projects = Projects.list_projects_exist()

    data =
      Enum.map(projects, fn project ->
        infor = _show_project_role_points(project, params.start_time, params.end_time)
        infor
      end)

    render(conn, :statistic_roles, %{data: data})
  end

  def _show_project_role_points(project, start_time, end_time) do
    start_week_infor =
      CalculateDate.week_to_month_with_working_days(start_time)

    end_week_infor =
      CalculateDate.week_to_month_with_working_days(end_time)

    project_points =
      UserWeekPoints.list_project_points_statistics(
        project.id,
        start_week_infor.week,
        start_week_infor.year,
        end_week_infor.week,
        end_week_infor.year
      )

    total_plan_point =
      Enum.reduce(project_points, 0, fn point, acc -> point.plan_point + acc end)

    total_actual_point =
      Enum.reduce(project_points, 0, fn point, acc -> point.actual_point + acc end)

    users =
      ProjectUsers.list_users_in_project(project.id)
      |> ProjectUsers.preload_project_user()
      |> Enum.group_by(& &1.user_role.name)

    data_role = _transform_data(users, project_points)

    %{
      start_date: start_time,
      end_date: end_time,
      project: project.name,
      plan_point: total_plan_point,
      actual_point: total_actual_point,
      data_role: data_role
    }
  end

  defp _calculate_point_performance(role_info) do
    Enum.reduce(role_info.members, 0, fn member, acc ->
      acc + member.actual_point * member.weight
    end)
  end

  defp _transform_data(users_data, user_week_points) do
    Enum.map(users_data, fn {role, users} ->
      role_info = %{
        role: role,
        plan_point: 0.0,
        actual_point: 0.0,
        members: []
      }

      role_info =
        Enum.reduce(users, role_info, fn %{user_id: user_id, user: user}, acc ->
          user_points = Enum.filter(user_week_points, &(&1.user_id == user_id))
          total_plan_point = Enum.reduce(user_points, 0.0, &(&1.plan_point + &2))
          total_actual_point = Enum.reduce(user_points, 0.0, &(&1.actual_point + &2))

          user_info = %{
            user_id: user_id,
            name: user.name,
            plan_point: total_plan_point,
            actual_point: total_actual_point,
            weight: user.weight,
            performance: (user.weight * total_actual_point) |> Float.floor(2)
          }

          %{
            role_info
            | plan_point: acc.plan_point + user_info.plan_point,
              actual_point: acc.actual_point + user_info.actual_point,
              members: acc.members ++ [user_info]
          }
        end)

      point_performance = _calculate_point_performance(role_info) |> Float.floor(2)

      role_info =
        role_info
        |> Map.put(:point_performance, point_performance)

      role_info
    end)
  end

  def show_project_points_in_month_test(conn, params) do
    params =
      @api_param_get_points_by_role
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(params.time)

    params =
      params
      |> Map.put(:month, week_infor.month)
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    project_points =
      UserWeekPoints.list_project_points_by_month(params.project_id, params.month, params.year)

    project = Projects.get_project!(params.project_id)

    total_plan_point =
      Enum.reduce(project_points, 0, fn point, acc -> point.plan_point + acc end)

    total_actual_point =
      Enum.reduce(project_points, 0, fn point, acc -> point.actual_point + acc end)

    users =
      ProjectUsers.list_users_in_project(params.project_id)
      |> ProjectUsers.preload_project_user()
      |> Enum.group_by(& &1.user_role.name)

    data_role = _transform_data(users, project_points)

    infor = %{
      month: params.month,
      year: params.year,
      project: project.name,
      plan_point: total_plan_point,
      actual_point: total_actual_point,
      data_role: data_role
    }

    render(conn, :statistic_roles, %{infor: infor})
  end
end

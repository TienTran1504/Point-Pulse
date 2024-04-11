defmodule PointPulseWeb.Statistic.GetStatisticPointPercentageController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.ProjectTypes
  alias PointPulse.ProjectUsers
  alias PointPulse.Users
  alias PointPulse.Utils.CalculateDate
  action_fallback(PointPulseWeb.FallbackController)

  @api_param_get_statistic_percentage %{
    user_id: [
      type: :integer,
      required: true
    ],
    start_time: [
      type: :string,
      required: true
    ],
    end_time: [
      type: :string,
      required: true
    ]
  }

  @api_param_get_users_statistic_percentage %{
    start_time: [
      type: :string,
      required: true
    ],
    end_time: [
      type: :string,
      required: true
    ]
  }

  def show_list_point_percentage(conn, params) do
    params =
      @api_param_get_users_statistic_percentage
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    users = Users.list_users_exist()

    data =
      Enum.map(users, fn user ->
        infor = _show_user_point_percentage(user.id, params.start_time, params.end_time)
        infor
      end)

    render(conn, :statistic_user_point_percentage, %{data: data})
  end

  defp _show_user_point_percentage(user_id, start_time, end_time) do
    start_week_infor =
      CalculateDate.week_to_month_with_working_days(start_time)

    end_week_infor =
      CalculateDate.week_to_month_with_working_days(end_time)

    user_points =
      UserWeekPoints.list_user_points_statistics(
        user_id,
        start_week_infor.week,
        start_week_infor.year,
        end_week_infor.week,
        end_week_infor.year
      )

    projects =
      ProjectUsers.list_projects_user_joined(user_id)
      |> ProjectUsers.preload_user_and_project()
      |> Enum.group_by(& &1.project.type_id)

    total_plan_point =
      Enum.reduce(user_points, 0, fn point, acc -> point.plan_point + acc end)

    data =
      _transfrom_data(projects, user_points)
      |> Enum.map(fn %{
                       project_type_id: project_type_id,
                       percent: percent,
                       plan_point: plan_point,
                       projects: projects
                     } ->
        project_type = ProjectTypes.get_project_type!(project_type_id)

        %{
          project_type_id: project_type_id,
          project_type: project_type.name,
          plan_point: plan_point,
          percent: percent,
          projects: projects
        }
      end)

    user = Users.get_user!(user_id)

    %{
      user_id: user_id,
      name: user.name,
      start_time: start_time,
      end_time: end_time,
      plan_point: total_plan_point,
      point_percentages: data
    }
  end

  def show_user_point_percentage_test(conn, params) do
    params =
      @api_param_get_statistic_percentage
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(params.time)

    params =
      params
      |> Map.put(:month, week_infor.month)
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    user_points =
      UserWeekPoints.list_user_points_by_month(params.user_id, params.month, params.year)

    projects =
      ProjectUsers.list_projects_user_joined(params.user_id)
      |> ProjectUsers.preload_user_and_project()
      |> Enum.group_by(& &1.project.type_id)

    total_plan_point =
      Enum.reduce(user_points, 0, fn point, acc -> point.plan_point + acc end)

    data =
      _transfrom_data(projects, user_points)
      |> Enum.map(fn %{
                       project_type_id: project_type_id,
                       percent: percent,
                       plan_point: plan_point,
                       projects: projects
                     } ->
        project_type = ProjectTypes.get_project_type!(project_type_id)

        %{
          project_type_id: project_type_id,
          project_type: project_type.name,
          plan_point: plan_point,
          percent: percent,
          projects: projects
        }
      end)

    user = Users.get_user!(params.user_id)

    infor = %{
      user_id: params.user_id,
      name: user.name,
      month: params.month,
      year: params.year,
      plan_point: total_plan_point,
      point_percentages: data
    }

    render(conn, :statistic_user_point_percentage, %{infor: infor})
  end

  defp _transfrom_data(projects, user_week_points) do
    Enum.map(projects, fn {type_id, project_users} ->
      type_info = %{
        project_type_id: type_id,
        percent: 0.0,
        plan_point: 0.0,
        projects: []
      }

      type_info =
        Enum.reduce(project_users, type_info, fn %{
                                                   project_id: project_id,
                                                   project: %{name: project_name}
                                                 },
                                                 acc ->
          user_points = Enum.filter(user_week_points, &(&1.project_id == project_id))

          total_plan_point =
            Enum.reduce(user_week_points, 0, fn point, acc -> point.plan_point + acc end)

          total_plan_point_in_project_type =
            Enum.reduce(user_points, 0, fn point, acc -> point.plan_point + acc end)

          project_info = %{
            project_id: project_id,
            name: project_name
          }

          new_percent =
            if acc.percent +
                 _calculate_percent(total_plan_point_in_project_type, total_plan_point) >=
                 1.0 do
              1.0
            else
              acc.percent + _calculate_percent(total_plan_point_in_project_type, total_plan_point)
            end

          %{
            type_info
            | percent: new_percent,
              plan_point: acc.plan_point + total_plan_point_in_project_type,
              projects: acc.projects ++ [project_info]
          }
        end)

      type_info
    end)
  end

  defp _calculate_percent(total_plan_point_in_project_type, total_plan_point) do
    if is_number(total_plan_point_in_project_type) and is_number(total_plan_point) and
         total_plan_point > 0 do
      total_plan_point_in_project_type / total_plan_point
    else
      0
    end
  end
end

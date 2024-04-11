defmodule PointPulseWeb.Statistic.GetStatisticProjectPointsController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.Projects
  alias PointPulse.Utils.CalculateDate
  action_fallback(PointPulseWeb.FallbackController)

  @api_param_get_project_points_by_time %{
    start_time: [
      type: :string,
      required: true
    ],
    end_time: [
      type: :string,
      required: true
    ]
  }

  @api_param_get_project_points %{
    project_id: [
      type: :integer,
      required: true
    ]
  }

  @api_param_get_all_projects_points %{
    time: [
      type: :string,
      required: true
    ]
  }
  def show_projects_points(conn, _params) do
    projects = Projects.list_projects_exist() |> Projects.preload_project_type()

    data =
      Enum.map(projects, fn project ->
        [formatted_start_date, _time] =
          DateTime.to_string(project.start_date) |> String.split(" ")

        [formatted_end_date, _time] =
          DateTime.to_string(project.end_date) |> String.split(" ")

        infor = _show_project_points(project, formatted_start_date, formatted_end_date)
        infor
      end)

    render(conn, :show_project_list, %{data: data})
  end

  def show_projects_points_by_time(conn, params) do
    params =
      @api_param_get_project_points_by_time
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    projects = Projects.list_projects_exist() |> Projects.preload_project_type()

    data =
      Enum.map(projects, fn project ->
        infor = _show_project_points(project, params.start_time, params.end_time)
        infor
      end)

    render(conn, :show_project_list, %{data: data})
  end

  defp _show_project_points(project, start_date, end_date) do
    start_week_infor = CalculateDate.week_to_month_with_working_days(start_date)

    end_week_infor = CalculateDate.week_to_month_with_working_days(end_date)

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

    %{
      project_id: project.id,
      project: project.name,
      project_type: project.project_type.name,
      start_time: start_date,
      end_time: end_date,
      plan_point: total_plan_point,
      actual_point: total_actual_point
    }
  end

  def show_project_points_in_month_test(conn, params) do
    params =
      @api_param_get_project_points
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

    render(conn, :show_project_points, %{
      project: project,
      plan_point: total_plan_point,
      actual_point: total_actual_point
    })
  end

  def show_projects_points_in_month_test(conn, params) do
    params =
      @api_param_get_all_projects_points
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
      UserWeekPoints.list_all_projects_points_by_month(params.month, params.year)
      |> UserWeekPoints.preload_project()

    project_points = Enum.group_by(project_points, & &1.project_id)

    project_summaries =
      project_points
      |> Enum.reduce(%{}, fn {project_id, user_week_points}, acc ->
        # Tính tổng plan_point và actual_point cho từng project_id
        total_plan_point =
          user_week_points
          |> Enum.map(& &1.plan_point)
          |> Enum.sum()

        total_actual_point =
          user_week_points
          |> Enum.map(& &1.actual_point)
          |> Enum.sum()

        project = Projects.get_project!(project_id)

        # Tạo map chứa thông tin của mỗi project_id
        project_info = %{
          project_id: project_id,
          project_name: project.name,
          total_plan_point: total_plan_point,
          total_actual_point: total_actual_point
        }

        # Thêm map vào kết quả (acc)
        Map.put(acc, project_id, project_info)
      end)
      |> Map.values()

    render(conn, :show_project_list, %{projects: project_summaries})
    # project = Projects.get_project!(params.project_id)

    # total_plan_point =
    #   Enum.reduce(project_points, 0, fn point, acc -> point.plan_point + acc end)

    # total_actual_point =
    #   Enum.reduce(project_points, 0, fn point, acc -> point.actual_point + acc end)

    # render(conn, :show_project_points, %{
    #   project: project,
    #   plan_point: total_plan_point,
    #   actual_point: total_actual_point
    # })
  end
end

defmodule PointPulseWeb.Project.GetProjectController do
  use PointPulseWeb, :controller
  alias PointPulse.Projects
  alias PointPulse.UserWeekPoints

  action_fallback PointPulseWeb.FallbackController

  @api_param_get_project %{
    project_id: [
      type: :integer,
      required: true
    ]
  }
  @api_param_get_project_paginated %{
    page: [
      type: :integer,
      number: [
        {:greater_than, 0}
      ],
      required: true
    ],
    page_size: [
      type: :integer,
      number: [
        {:greater_than, 0}
      ],
      required: true
    ]
  }
  def show_list(conn, _params) do
    projects = Projects.list_projects_exist()
    projects = Projects.preload_project_type(projects)
    render(conn, :show_list, projects: projects)
  end

  def show_list_unblocked(conn, _params) do
    projects = Projects.list_projects_exist_and_unblocked()
    projects = Projects.preload_project_type(projects)
    render(conn, :show_list, projects: projects)
  end

  def show_list_projects_paginated(conn, params) do
    params =
      @api_param_get_project_paginated
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    projects =
      Projects.list_projects_exist_and_paginate(params.page, params.page_size)

    # |> Projects.preload_project_type()

    render(conn, :show_list, projects: projects)
  end

  def show(conn, %{"id" => id}) do
    project_params = %{project_id: id}

    project_params =
      @api_param_get_project
      |> Validator.parse(project_params)
      |> Validator.get_validated_changes!()

    case Projects.get_project!(project_params.project_id) do
      nil ->
        render(conn, :show_message, message: "Can't find project")

      project ->
        user_week_points =
          UserWeekPoints.list_member_week_points_in_project(project_params.project_id)

        total_plan_point =
          Enum.reduce(user_week_points, 0, fn week_point, acc ->
            acc + week_point.plan_point
          end)

        total_actual_point =
          Enum.reduce(user_week_points, 0, fn week_point, acc ->
            acc + week_point.actual_point
          end)

        project = Projects.preload_project_type(project)

        render(conn, :show, %{
          project: project,
          actual_point: total_actual_point,
          plan_point: total_plan_point,
          week_points: user_week_points
        })
    end
  end
end

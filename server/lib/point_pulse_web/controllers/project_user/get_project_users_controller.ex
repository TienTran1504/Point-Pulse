defmodule PointPulseWeb.ProjectUser.GetProjectUserController do
  use PointPulseWeb, :controller
  alias PointPulse.ProjectUsers
  alias PointPulse.UserWeekPoints

  action_fallback PointPulseWeb.FallbackController

  @api_param_get_users_in_project %{
    project_id: [
      type: :integer,
      required: true
    ]
  }

  @api_param_get_user_in_project %{
    project_id: [
      type: :integer,
      required: true
    ],
    user_id: [
      type: :integer,
      required: true
    ]
  }
  @api_param_get_users_in_project_paginated %{
    project_id: [
      type: :integer,
      required: true
    ],
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
  def show_users_in_project(conn, %{"project_id" => project_id}) do
    project_user_params = %{project_id: project_id}

    project_user_params =
      @api_param_get_users_in_project
      |> Validator.parse(project_user_params)
      |> Validator.get_validated_changes!()

    project_users =
      project_user_params.project_id
      |> ProjectUsers.list_users_in_project()
      |> ProjectUsers.preload_project_user()

    render(conn, :show_list, project_users: project_users)
  end

  def show_users_in_project_paginated(conn, project_user_params) do
    %{project_id: project_id, page: page, page_size: page_size} =
      @api_param_get_users_in_project_paginated
      |> Validator.parse(project_user_params)
      |> Validator.get_validated_changes!()

    project_users = ProjectUsers.list_project_users_and_paginate(project_id, page, page_size)
    render(conn, :show_list, project_users: project_users)
  end

  def show_list(conn, _params) do
    project_users = ProjectUsers.list_project_users() |> ProjectUsers.preload_user()
    render(conn, :show_list, project_users: project_users)
  end

  def show_user_in_project(conn, project_user_params) do
    project_user_params =
      @api_param_get_user_in_project
      |> Validator.parse(project_user_params)
      |> Validator.get_validated_changes!()

    case ProjectUsers.get_user_in_project!(
           project_user_params.project_id,
           project_user_params.user_id
         ) do
      nil ->
        render(conn, :show_message, message: "Don't have this user in project")

      project_user ->
        plan_point =
          _get_total_user_week_points(
            project_user_params.project_id,
            project_user_params.user_id
          )

        new_project_user = ProjectUsers.preload_project_user(project_user)

        render(conn, :show_point, %{project_user: new_project_user, plan_point: plan_point})
    end
  end

  def show_personal_projects(conn, _project_user_params) do
    projects =
      ProjectUsers.list_projects_user_joined(conn.assigns.user.id) |> ProjectUsers.preload_user()

    render(conn, :show_list, project_users: projects)
  end

  def show_managing_projects(conn, _project_user_params) do
    projects =
      ProjectUsers.list_projects_user_joined(conn.assigns.user.id) |> ProjectUsers.preload_user()

    projects = Enum.filter(projects, fn user -> user.user_role.name == "manager" end)
    render(conn, :show_list, project_users: projects)
  end

  defp _get_total_user_week_points(project_id, user_id) do
    user_week_points =
      UserWeekPoints.list_user_week_points_in_project(project_id, user_id)

    total_week_point =
      Enum.reduce(user_week_points, 0, fn week_point, acc ->
        acc + week_point.plan_point
      end)

    total_week_point
  end
end

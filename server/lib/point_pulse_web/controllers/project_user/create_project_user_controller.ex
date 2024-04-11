defmodule PointPulseWeb.ProjectUser.CreateProjectUserController do
  use PointPulseWeb, :controller

  alias PointPulse.ProjectUsers
  alias PointPulse.ProjectUsers.ProjectUser

  action_fallback PointPulseWeb.FallbackController

  @api_param_create_project_user %{
    project_id: [
      type: :integer,
      required: true
    ],
    user_id: [
      type: :integer,
      required: true
    ],
    user_role_id: [
      type: :integer,
      required: true
    ]
  }

  def create(conn, project_user_params) do
    project_user_params =
      @api_param_create_project_user
      |> Validator.parse(project_user_params)
      |> Validator.get_validated_changes!()

    case ProjectUsers.has_user_in_project?(
           project_user_params.project_id,
           project_user_params.user_id
         ) do
      false ->
        with {:ok, %ProjectUser{} = project_user} <-
               ProjectUsers.create_project_user_with_metadata(
                 conn.assigns.user.id,
                 project_user_params
               ) do
          new_project_user = ProjectUsers.preload_project_user(project_user)

          conn
          |> put_status(:created)
          |> render(:show, project_user: new_project_user)
        end

      true ->
        render(conn, :show_message, message: "Already have this user in this project")
    end
  end
end

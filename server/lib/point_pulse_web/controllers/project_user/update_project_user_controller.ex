defmodule PointPulseWeb.ProjectUser.UpdateProjectUserController do
  use PointPulseWeb, :controller

  alias PointPulse.ProjectUsers
  alias PointPulse.ProjectUsers.ProjectUser

  action_fallback PointPulseWeb.FallbackController

  @api_param_update_project_user %{
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

  def update(conn, project_user_params) do
    project_user_params =
      @api_param_update_project_user
      |> Validator.parse(project_user_params)
      |> Validator.get_validated_changes!()

    case ProjectUsers.get_user_in_project!(
           project_user_params.project_id,
           project_user_params.user_id
         ) do
      nil ->
        render(conn, :show_message, message: "Don't have user in this project")

      project_user ->
        with {:ok, %ProjectUser{} = updated_project_user} <-
               ProjectUsers.update_project_user_with_metadata(
                 conn.assigns.user.id,
                 project_user,
                 project_user_params
               ) do
          new_project_user = ProjectUsers.preload_project_user(updated_project_user)

          render(conn, :show_updated_project_user, project_user: new_project_user)
        end
    end
  end
end

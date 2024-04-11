defmodule PointPulseWeb.ProjectUser.DeleteProjectUserController do
  use PointPulseWeb, :controller
  alias PointPulse.ProjectUsers
  alias PointPulse.ProjectUsers.ProjectUser

  action_fallback PointPulseWeb.FallbackController

  @api_param_delete_user_in_project %{
    project_id: [
      type: :integer,
      required: true
    ],
    user_id: [
      type: :integer,
      required: true
    ]
  }

  def delete(conn, project_user_params) do
    project_user_params =
      @api_param_delete_user_in_project
      |> Validator.parse(project_user_params)
      |> Validator.get_validated_changes!()

    project_user =
      ProjectUsers.get_user_in_project!(
        project_user_params.project_id,
        project_user_params.user_id
      )

    with {:ok, %ProjectUser{}} <- ProjectUsers.delete_project_user(project_user) do
      render(conn, :show_message,
        message:
          "Delete User ID #{project_user_params.user_id} in Project ID #{project_user_params.project_id}"
      )
    end
  end
end

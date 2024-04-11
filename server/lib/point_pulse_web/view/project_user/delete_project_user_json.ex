defmodule PointPulseWeb.ProjectUser.DeleteProjectUserJSON do
  alias PointPulse.ProjectUsers.ProjectUser

  def show(%{project: project}) do
    %{status: :OK, data: data(project)}
  end

  def show_message(%{message: message}) do
    %{status: :BAD_REQUEST, message: message}
  end

  defp data(%ProjectUser{} = project_user) do
    %{
      id: project_user.id,
      project_id: project_user.project_id,
      user_id: project_user.user_id,
      user_role_id: project_user.user_role_id,
      inserted_at: project_user.inserted_at,
      updated_at: project_user.updated_at,
      inserted_by: project_user.inserted_by,
      updated_by: project_user.updated_by
    }
  end
end

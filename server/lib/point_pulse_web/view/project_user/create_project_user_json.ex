defmodule PointPulseWeb.ProjectUser.CreateProjectUserJSON do
  alias PointPulse.ProjectUsers.ProjectUser

  def show(%{project_user: project_user}) do
    %{status: :OK, data: data(project_user)}
  end

  def show_message(%{message: message}) do
    %{status: :BAD_REQEUST, message: message}
  end

  defp data(%ProjectUser{} = project_user) do
    %{
      id: project_user.id,
      project_id: project_user.project_id,
      user_id: project_user.user_id,
      user_name: project_user.user.name,
      user_email: project_user.user.email,
      user_role_id: project_user.user_role_id,
      user_role: project_user.user_role.name,
      inserted_at: project_user.inserted_at,
      updated_at: project_user.updated_at,
      inserted_by: project_user.inserted_by,
      updated_by: project_user.updated_by
    }
  end

  # defp data_created(%ProjectUser{} = project_user) do
  #   %{
  #     id: project_user.id,
  #     name: project_user.name,
  #     type_id: project_user.type_id,
  #     plan_point: project_user.plan_point,
  #     locked: project_user.locked,
  #     inserted_at: project_user.inserted_at,
  #     updated_at: project_user.updated_at,
  #     deleted_at: project_user.deleted_at,
  #     inserted_by: project_user.inserted_by,
  #     updated_by: project_user.updated_by
  #   }
  # end
end

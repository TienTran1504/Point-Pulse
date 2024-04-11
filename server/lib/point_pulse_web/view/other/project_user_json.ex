defmodule PointPulseWeb.ProjectUserJSON do
  alias PointPulse.ProjectUsers.ProjectUser

  @doc """
  Renders a list of project_users.
  """
  def index(%{project_users: project_users}) do
    %{data: for(project_user <- project_users, do: data(project_user))}
  end

  @doc """
  Renders a single project_user.
  """
  def show(%{project_user: project_user}) do
    %{data: data(project_user)}
  end

  defp data(%ProjectUser{} = project_user) do
    %{
      id: project_user.id,
      project_id: project_user.project_id,
      user_id: project_user.user_id,
      user_role_id: project_user.user_role_id,
      inserted_by: project_user.inserted_by,
      updated_by: project_user.updated_by
    }
  end
end

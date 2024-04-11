defmodule PointPulseWeb.ProjectUserController do
  use PointPulseWeb, :controller

  alias PointPulse.ProjectUsers
  alias PointPulse.ProjectUsers.ProjectUser

  action_fallback PointPulseWeb.FallbackController

  def index(conn, _params) do
    project_users = ProjectUsers.list_project_users()
    render(conn, :index, project_users: project_users)
  end

  def create(conn, %{"project_user" => project_user_params}) do
    with {:ok, %ProjectUser{} = project_user} <- ProjectUsers.create_project_user(project_user_params) do
      conn
      |> put_status(:created)
      |> render(:show, project_user: project_user)
    end
  end

  def show(conn, %{"id" => id}) do
    project_user = ProjectUsers.get_project_user!(id)
    render(conn, :show, project_user: project_user)
  end

  def update(conn, %{"id" => id, "project_user" => project_user_params}) do
    project_user = ProjectUsers.get_project_user!(id)

    with {:ok, %ProjectUser{} = project_user} <- ProjectUsers.update_project_user(project_user, project_user_params) do
      render(conn, :show, project_user: project_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    project_user = ProjectUsers.get_project_user!(id)

    with {:ok, %ProjectUser{}} <- ProjectUsers.delete_project_user(project_user) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule PointPulseWeb.ProjectTypeController do
  use PointPulseWeb, :controller

  alias PointPulse.ProjectTypes
  alias PointPulse.ProjectTypes.ProjectType

  action_fallback PointPulseWeb.FallbackController

  def index(conn, _params) do
    project_types = ProjectTypes.list_project_types()
    render(conn, :index, project_types: project_types)
  end

  def create(conn, %{"project_type" => project_type_params}) do
    with {:ok, %ProjectType{} = project_type} <- ProjectTypes.create_project_type(project_type_params) do
      conn
      |> put_status(:created)
      |> render(:show, project_type: project_type)
    end
  end

  def show(conn, %{"id" => id}) do
    project_type = ProjectTypes.get_project_type!(id)
    render(conn, :show, project_type: project_type)
  end

  def update(conn, %{"id" => id, "project_type" => project_type_params}) do
    project_type = ProjectTypes.get_project_type!(id)

    with {:ok, %ProjectType{} = project_type} <- ProjectTypes.update_project_type(project_type, project_type_params) do
      render(conn, :show, project_type: project_type)
    end
  end

  def delete(conn, %{"id" => id}) do
    project_type = ProjectTypes.get_project_type!(id)

    with {:ok, %ProjectType{}} <- ProjectTypes.delete_project_type(project_type) do
      send_resp(conn, :no_content, "")
    end
  end
end

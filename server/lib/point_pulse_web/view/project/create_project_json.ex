defmodule PointPulseWeb.Project.CreateProjectJSON do
  alias PointPulse.Projects.Project

  def show(%{project: project}) do
    %{status: :OK, data: data(project)}
  end

  def show_message(%{message: message}) do
    %{status: :BAD_REQUEST, message: message}
  end

  defp data(%Project{} = project) do
    %{
      id: project.id,
      name: project.name,
      type_id: project.type_id,
      locked: project.locked,
      start_date: project.start_date,
      end_date: project.end_date,
      inserted_at: project.inserted_at,
      updated_at: project.updated_at,
      deleted_at: project.deleted_at,
      inserted_by: project.inserted_by,
      updated_by: project.updated_by
    }
  end
end

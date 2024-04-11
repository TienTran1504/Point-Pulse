defmodule PointPulseWeb.ProjectType.GetProjectTypeJSON do
  alias PointPulse.ProjectTypes.ProjectType

  def show(%{project_type: project_type}) do
    %{status: :OK, data: data(project_type)}
  end

  def show_message(%{message: message}) do
    %{status: :BAD_REQUEST, message: message}
  end

  def show_list(%{project_types: project_types}) do
    %{status: :OK, data: for(project_type <- project_types, do: data(project_type))}
  end

  defp data(%ProjectType{} = project_type) do
    %{
      id: project_type.id,
      name: project_type.name,
      inserted_at: project_type.inserted_at,
      updated_at: project_type.updated_at,
      deleted_at: project_type.deleted_at,
      inserted_by: project_type.inserted_by,
      updated_by: project_type.updated_by
    }
  end
end

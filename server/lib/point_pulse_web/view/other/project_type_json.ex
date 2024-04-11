defmodule PointPulseWeb.ProjectTypeJSON do
  alias PointPulse.ProjectTypes.ProjectType

  @doc """
  Renders a list of project_types.
  """
  def index(%{project_types: project_types}) do
    %{data: for(project_type <- project_types, do: data(project_type))}
  end

  @doc """
  Renders a single project_type.
  """
  def show(%{project_type: project_type}) do
    %{data: data(project_type)}
  end

  defp data(%ProjectType{} = project_type) do
    %{
      id: project_type.id,
      name: project_type.name,
      inserted_by: project_type.inserted_by,
      updated_by: project_type.updated_by
    }
  end
end

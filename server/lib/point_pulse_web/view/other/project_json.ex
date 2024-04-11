defmodule PointPulseWeb.ProjectJSON do
  alias PointPulse.Projects.Project

  @doc """
  Renders a list of projects.
  """
  def index(%{projects: projects}) do
    %{data: for(project <- projects, do: data(project))}
  end

  @doc """
  Renders a single project.
  """
  def show(%{project: project}) do
    %{data: data(project)}
  end

  defp data(%Project{} = project) do
    %{
      id: project.id,
      name: project.name,
      type_id: project.type_id,
      locked: project.locked,
      inserted_by: project.inserted_by,
      updated_by: project.updated_by
    }
  end
end

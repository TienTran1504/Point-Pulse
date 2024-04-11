defmodule PointPulseWeb.Project.DeleteProjectController do
  use PointPulseWeb, :controller
  alias PointPulse.Projects
  alias PointPulse.Projects.Project

  action_fallback PointPulseWeb.FallbackController

  @api_param_delete_project %{
    project_id: [
      type: :integer,
      required: true
    ]
  }

  def delete(conn, project_params) do
    deleted_at = DateTime.utc_now()

    project_params =
      @api_param_delete_project
      |> Validator.parse(project_params)
      |> Validator.get_validated_changes!()

    project_params =
      project_params
      |> Map.put(:deleted_at, deleted_at)

    project = Projects.get_project!(project_params.project_id)

    with {:ok, %Project{} = project} <-
           Projects.update_project_with_metadata(conn.assigns.user.id, project, project_params) do
      render(conn, :show, project: project)
    end
  end
end

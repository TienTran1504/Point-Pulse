defmodule PointPulseWeb.Project.UpdateProjectController do
  use PointPulseWeb, :controller

  alias PointPulse.Projects
  alias PointPulse.Projects.Project

  action_fallback PointPulseWeb.FallbackController

  @api_param_update_project %{
    project_id: [
      type: :integer,
      required: true
    ],
    name: [
      type: :string
    ],
    type_id: [
      type: :integer
    ],
    locked: [
      type: :boolean
    ],
    start_date: [
      type: :date,
      required: true
    ],
    end_date: [
      type: :date,
      required: true
    ]
  }

  def update(conn, project_params) do
    project_params =
      @api_param_update_project
      |> Validator.parse(project_params)
      |> Validator.get_validated_changes!()

    case Projects.get_project!(project_params.project_id) do
      nil ->
        render(conn, :show_message, message: "Don't have project to update")

      project ->
        with {:ok, %Project{} = updated_project} <-
               Projects.update_project_with_metadata(
                 conn.assigns.user.id,
                 project,
                 project_params
               ) do
          render(conn, :show_updated_project, project: updated_project)
        end
    end
  end
end

defmodule PointPulseWeb.Project.CreateProjectController do
  use PointPulseWeb, :controller

  alias PointPulse.Projects
  alias PointPulse.Projects.Project

  action_fallback(PointPulseWeb.FallbackController)

  @api_param_create_project %{
    name: [
      type: :string,
      required: true
    ],
    type_id: [
      type: :integer,
      required: true
    ],
    locked: [
      type: :boolean,
      required: true
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

  def create(conn, project_params) do
    project_params =
      @api_param_create_project
      |> Validator.parse(project_params)
      |> Validator.get_validated_changes!()

    with {:ok, %Project{} = project} <-
           Projects.create_project_with_metadata(conn.assigns.user.id, project_params) do
      conn
      |> put_status(:created)
      |> render(:show, project: project)
    end
  end
end

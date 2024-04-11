defmodule PointPulseWeb.ProjectType.CreateProjectTypeController do
  use PointPulseWeb, :controller
  alias PointPulse.ProjectTypes
  alias PointPulse.ProjectTypes.ProjectType

  action_fallback PointPulseWeb.FallbackController

  @api_param_create_project_type %{
    name: [
      type: :string,
      required: true
    ]
  }

  def create(conn, project_type_params) do
    project_type_params =
      @api_param_create_project_type
      |> Validator.parse(project_type_params)
      |> Validator.get_validated_changes!()

    case ProjectTypes.has_project_type_name?(project_type_params.name) do
      false ->
        with {:ok, %ProjectType{} = project_type} <-
               ProjectTypes.create_project_type_with_metadata(
                 conn.assigns.user.id,
                 project_type_params
               ) do
          conn
          |> put_status(:created)
          |> render(:show, project_type: project_type)
        end

      true ->
        render(conn, :show_message, message: "Đã tồn tại loại dự án trong hệ thống")
    end
  end
end

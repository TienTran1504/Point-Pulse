defmodule PointPulseWeb.ProjectType.UpdateProjectTypeController do
  use PointPulseWeb, :controller
  alias PointPulse.ProjectTypes
  alias PointPulse.ProjectTypes.ProjectType

  action_fallback PointPulseWeb.FallbackController

  @api_param_update_project_type %{
    project_type_id: [
      type: :integer,
      required: true
    ],
    name: [
      type: :string,
      required: true
    ]
  }
  def update(conn, project_type_params) do
    project_type_params =
      @api_param_update_project_type
      |> Validator.parse(project_type_params)
      |> Validator.get_validated_changes!()

    case ProjectTypes.has_project_type_name?(project_type_params.name) do
      false ->
        project_type = ProjectTypes.get_project_type!(project_type_params.project_type_id)

        with {:ok, %ProjectType{} = new_project_type} <-
               ProjectTypes.update_project_type_with_metadata(
                 conn.assigns.user.id,
                 project_type,
                 project_type_params
               ) do
          render(conn, :show, project_type: new_project_type)
        end

      true ->
        render(conn, :show_message, message: "Đã tồn tại tên loại dự án trong hệ thống")
    end
  end
end

defmodule PointPulseWeb.ProjectType.DeleteProjectTypeController do
  use PointPulseWeb, :controller
  alias PointPulse.ProjectTypes
  alias PointPulse.ProjectTypes.ProjectType

  action_fallback PointPulseWeb.FallbackController

  @api_param_delete_project_type %{
    project_type_id: [
      type: :integer,
      required: true
    ]
  }
  def delete(conn, project_type_params) do
    deleted_at = DateTime.utc_now()

    project_type_params =
      @api_param_delete_project_type
      |> Validator.parse(project_type_params)
      |> Validator.get_validated_changes!()

    project_type_params =
      project_type_params
      |> Map.put(:deleted_at, deleted_at)

    case ProjectTypes.get_project_type!(project_type_params.project_type_id) do
      nil ->
        render(conn, :show_message, message: "Không tồn tại loại dự án trong hệ thống")

      project_type ->
        with {:ok, %ProjectType{} = new_project_type} <-
               ProjectTypes.update_project_type_with_metadata(
                 conn.assigns.user.id,
                 project_type,
                 project_type_params
               ) do
          render(conn, :show, project_type: new_project_type)
        end
    end
  end
end

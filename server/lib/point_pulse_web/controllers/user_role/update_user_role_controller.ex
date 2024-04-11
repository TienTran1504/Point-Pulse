defmodule PointPulseWeb.UserRole.UpdateUserRoleController do
  use PointPulseWeb, :controller
  alias PointPulse.UserRoles
  alias PointPulse.UserRoles.UserRole

  action_fallback PointPulseWeb.FallbackController

  @api_param_update_user_role %{
    user_role_id: [
      type: :integer,
      required: true
    ],
    name: [
      type: :string,
      required: true
    ]
  }
  def update(conn, user_role_params) do
    user_role_params =
      @api_param_update_user_role
      |> Validator.parse(user_role_params)
      |> Validator.get_validated_changes!()

    case UserRoles.has_user_role?(user_role_params.name) do
      false ->
        user_role = UserRoles.get_user_role!(user_role_params.user_role_id)

        with {:ok, %UserRole{} = new_user_role} <-
               UserRoles.update_user_role_with_metadata(
                 conn.assigns.user.id,
                 user_role,
                 user_role_params
               ) do
          render(conn, :show, user_role: new_user_role)
        end

      true ->
        render(conn, :show_message, message: "Đã tồn tại loại vai trò nhân viên trong hệ thống")
    end
  end
end

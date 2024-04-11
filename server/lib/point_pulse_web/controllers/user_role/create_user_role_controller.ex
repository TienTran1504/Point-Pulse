defmodule PointPulseWeb.UserRole.CreateUserRoleController do
  use PointPulseWeb, :controller
  alias PointPulse.UserRoles
  alias PointPulse.UserRoles.UserRole

  action_fallback PointPulseWeb.FallbackController

  @api_param_create_user_role %{
    name: [
      type: :string,
      required: true
    ]
  }

  def create(conn, user_role_params) do
    user_role_params =
      @api_param_create_user_role
      |> Validator.parse(user_role_params)
      |> Validator.get_validated_changes!()

    case UserRoles.has_user_role?(user_role_params.name) do
      false ->
        with {:ok, %UserRole{} = user_role} <-
               UserRoles.create_user_role_with_metadata(conn.assigns.user.id, user_role_params) do
          conn
          |> put_status(:created)
          |> render(:show, user_role: user_role)
        end

      true ->
        render(conn, :show_message,
          message: "Đã tồn tại tên loại vai trò nhân viên trong hệ thống"
        )
    end
  end
end

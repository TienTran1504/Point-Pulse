defmodule PointPulseWeb.Permission.CreateUserPermissionsController do
  use PointPulseWeb, :controller

  alias PointPulse.UserPermissions
  alias PointPulse.UserPermissions.UserPermission

  action_fallback PointPulseWeb.FallbackController

  @api_param_create_user_permission %{
    user_id: [
      type: :integer,
      required: true
    ],
    permission_id: [
      type: :integer,
      required: true
    ]
  }

  def create(conn, params) do
    params =
      @api_param_create_user_permission
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    params =
      params
      |> Map.put(:inserted_by, conn.assigns.user.id)

    with {:ok, %UserPermission{} = user_permission} <-
           UserPermissions.create_user_permission(params) do
      conn
      |> put_status(:created)
      |> render(:show, user_permission: user_permission)
    end
  end

  def create_permission(inserted_by, user_id, permissions) do
    # Ex: user_id: 3, permissions: [1,2,3,4,5,1], inserted_by: 1
    permissions = [5 | permissions]

    unique_permissions =
      permissions
      |> Enum.uniq()
      |> Enum.sort()

    for permission <- unique_permissions do
      user_permission_params = %{
        user_id: user_id,
        permission_id: permission
      }

      UserPermissions.create_user_permission_with_metadata(
        inserted_by,
        user_permission_params
      )
    end

    unique_permissions
  end
end

defmodule PointPulseWeb.Permission.UpdateUserPermissionsController do
  use PointPulseWeb, :controller

  alias PointPulse.UserPermissions

  action_fallback PointPulseWeb.FallbackController

  def update_permission(updated_by, user_id, permissions) do
    # Ex: user_id: 3, permissions: [1,2,3,4,5,1], inserted_by: 1
    unique_permissions =
      permissions
      |> Enum.uniq()
      |> Enum.sort()
      |> Enum.filter(fn x -> x != 5 end)

    UserPermissions.delete_user_permissions(user_id)

    for permission <- unique_permissions do
      user_permission_params = %{
        user_id: user_id,
        permission_id: permission
      }

      UserPermissions.create_user_permission_with_metadata(
        updated_by,
        user_permission_params
      )
    end

    (unique_permissions ++ [5]) |> Enum.sort()
  end
end

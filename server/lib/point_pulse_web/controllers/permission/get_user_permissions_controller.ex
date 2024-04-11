defmodule PointPulseWeb.Permission.GetUserPermissionsController do
  use PointPulseWeb, :controller

  alias PointPulse.UserPermissions
  # alias PointPulse.UserPermissions.UserPermission
  # alias PointPulse.Permissions
  # alias PointPulse.Permissions.Permission

  action_fallback PointPulseWeb.FallbackController

  def show(conn, _params) do
    user_permissions = UserPermissions.get_person_permissions(conn.assigns.user.id)
    result = UserPermissions.preload_permission(user_permissions)
    render(conn, :show_list, %{user_permissions: result})
  end

  def get_user_permission(conn, %{"id" => id}) do
    user_permissions = UserPermissions.get_person_permissions(id)
    result = UserPermissions.preload_permission(user_permissions)
    render(conn, :show_list, %{user_permissions: result})
  end
end

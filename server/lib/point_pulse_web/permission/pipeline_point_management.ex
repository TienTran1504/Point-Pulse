defmodule PointPulseWeb.Permission.PipelinePointManagement do
  import PointPulse.Utils.PermissionConstant
  alias PointPulse.Users
  alias PointPulse.UserPermissions
  alias PointPulseWeb.{Auth.ErrorResponse}

  def init(_options) do
  end

  def call(conn, _options) do
    permissions = _get_user_permission(conn)

    has_permission =
      Enum.any?(permissions, fn permission ->
        permission.permission.name == permission_point()
      end)

    if has_permission do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end

  defp _get_user_permission(conn) do
    user = Users.get_user!(conn.assigns.user.id) |> Users.preload_user_permissions()
    UserPermissions.preload_permission(user.user_permissions)
  end
end

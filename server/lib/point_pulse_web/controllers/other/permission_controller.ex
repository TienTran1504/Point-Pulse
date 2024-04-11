defmodule PointPulseWeb.PermissionController do
  use PointPulseWeb, :controller

  alias PointPulse.Permissions
  alias PointPulse.Permissions.Permission

  action_fallback PointPulseWeb.FallbackController

  def index(conn, _params) do
    permissions = Permissions.list_permissions()
    render(conn, :index, permissions: permissions)
  end

  def create(conn, %{"permission" => permission_params}) do
    with {:ok, %Permission{} = permission} <- Permissions.create_permission(permission_params) do
      conn
      |> put_status(:created)
      |> render(:show, permission: permission)
    end
  end

  def show(conn, %{"id" => id}) do
    permission = Permissions.get_permission!(id)
    render(conn, :show, permission: permission)
  end

  def update(conn, %{"id" => id, "permission" => permission_params}) do
    permission = Permissions.get_permission!(id)

    with {:ok, %Permission{} = permission} <- Permissions.update_permission(permission, permission_params) do
      render(conn, :show, permission: permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    permission = Permissions.get_permission!(id)

    with {:ok, %Permission{}} <- Permissions.delete_permission(permission) do
      send_resp(conn, :no_content, "")
    end
  end
end

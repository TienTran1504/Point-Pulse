defmodule PointPulseWeb.UserPermissionController do
  use PointPulseWeb, :controller

  alias PointPulse.UserPermissions
  alias PointPulse.UserPermissions.UserPermission

  action_fallback(PointPulseWeb.FallbackController)

  @api_param_create_user_permission %{
    user_id: [
      type: :integer,
      required: true
    ],
    permission_id: [
      type: :integer,
      required: true
    ],
    inserted_by: [
      type: :integer,
      required: true
    ],
    updated_by: [
      type: :integer,
      required: true
    ]
  }

  def index(conn, _params) do
    user_permissions = UserPermissions.list_user_permissions()
    render(conn, :index, user_permissions: user_permissions)
  end

  def create(conn, params) do
    params =
      params
      |> Map.put("inserted_by", conn.assigns.user.id)
      |> Map.put("updated_by", conn.assigns.user.id)

    params =
      @api_param_create_user_permission
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    with {:ok, %UserPermission{} = user_permission} <-
           UserPermissions.create_user_permission(params) do
      conn
      |> put_status(:created)
      |> render(:show, user_permission: user_permission)
    end
  end

  def show(conn, %{"id" => id}) do
    user_permission = UserPermissions.get_user_permission!(id)
    render(conn, :show, user_permission: user_permission)
  end

  def update(conn, %{"id" => id, "user_permission" => user_permission_params}) do
    user_permission = UserPermissions.get_user_permission!(id)

    with {:ok, %UserPermission{} = user_permission} <-
           UserPermissions.update_user_permission(user_permission, user_permission_params) do
      render(conn, :show, user_permission: user_permission)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_permission = UserPermissions.get_user_permission!(id)

    with {:ok, %UserPermission{}} <- UserPermissions.delete_user_permission(user_permission) do
      send_resp(conn, :no_content, "")
    end
  end
end

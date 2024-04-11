defmodule PointPulseWeb.UserRoleController do
  use PointPulseWeb, :controller

  alias PointPulse.UserRoles
  alias PointPulse.UserRoles.UserRole

  action_fallback PointPulseWeb.FallbackController

  def index(conn, _params) do
    user_roles = UserRoles.list_user_roles()
    render(conn, :index, user_roles: user_roles)
  end

  def create(conn, %{"user_role" => user_role_params}) do
    with {:ok, %UserRole{} = user_role} <- UserRoles.create_user_role(user_role_params) do
      conn
      |> put_status(:created)
      |> render(:show, user_role: user_role)
    end
  end

  def show(conn, %{"id" => id}) do
    user_role = UserRoles.get_user_role!(id)
    render(conn, :show, user_role: user_role)
  end

  def update(conn, %{"id" => id, "user_role" => user_role_params}) do
    user_role = UserRoles.get_user_role!(id)

    with {:ok, %UserRole{} = user_role} <- UserRoles.update_user_role(user_role, user_role_params) do
      render(conn, :show, user_role: user_role)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_role = UserRoles.get_user_role!(id)

    with {:ok, %UserRole{}} <- UserRoles.delete_user_role(user_role) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule PointPulseWeb.Permission.GetUserPermissionsJSON do
  alias PointPulse.UserPermissions.UserPermission

  @doc """
  Renders a list of user_permissions.
  """
  def index(%{user_permissions: user_permissions}) do
    %{data: for(user_permission <- user_permissions, do: data(user_permission))}
  end

  @doc """
  Renders a single user_permission.
  """
  def show(%{user_permission: user_permission}) do
    %{status: :OK, data: data(user_permission)}
  end

  def show_list(%{user_permissions: user_permissions}) do
    %{
      status: :OK,
      data: for(user_permission <- user_permissions, do: data_permission(user_permission))
    }
  end

  defp data(%UserPermission{} = user_permission) do
    %{
      id: user_permission.id,
      user_id: user_permission.user_id,
      permission_id: user_permission.permission_id,
      inserted_at: user_permission.inserted_at,
      updated_at: user_permission.updated_at,
      inserted_by: user_permission.inserted_by,
      updated_by: user_permission.inserted_by
    }
  end

  defp data_permission(%UserPermission{} = user_permission) do
    %{
      id: user_permission.id,
      user_id: user_permission.user_id,
      permission_id: user_permission.permission_id,
      permission_name: user_permission.permission.name,
      inserted_at: user_permission.inserted_at,
      updated_at: user_permission.updated_at,
      inserted_by: user_permission.inserted_by,
      updated_by: user_permission.inserted_by
    }
  end
end

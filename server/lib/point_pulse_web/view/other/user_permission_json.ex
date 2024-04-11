defmodule PointPulseWeb.UserPermissionJSON do
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
    %{data: data(user_permission)}
  end

  def show_list(%{user_permissions: user_permissions}) do
    %{data: Enum.map(user_permissions, &data/1)}
  end

  defp data(%UserPermission{} = user_permission) do
    %{
      id: user_permission.id,
      user_id: user_permission.user_id,
      permission_id: user_permission.permission_id,
      inserted_at: user_permission.inserted_at,
      inserted_by: user_permission.inserted_by
    }
  end
end

defmodule PointPulseWeb.PermissionJSON do
  alias PointPulse.Permissions.Permission

  @doc """
  Renders a list of permissions.
  """
  def index(%{permissions: permissions}) do
    %{data: for(permission <- permissions, do: data(permission))}
  end

  @doc """
  Renders a single permission.
  """
  def show(%{permission: permission}) do
    %{data: data(permission)}
  end

  defp data(%Permission{} = permission) do
    %{
      id: permission.id,
      name: permission.name
    }
  end
end

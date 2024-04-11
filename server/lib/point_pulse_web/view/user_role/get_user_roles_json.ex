defmodule PointPulseWeb.UserRole.GetUserRoleJSON do
  alias PointPulse.UserRoles.UserRole

  def show(%{user_role: user_role}) do
    %{status: :OK, data: data(user_role)}
  end

  def show_list(%{user_roles: user_roles}) do
    %{status: :OK, data: for(user_role <- user_roles, do: data(user_role))}
  end

  defp data(%UserRole{} = user_role) do
    %{
      id: user_role.id,
      name: user_role.name,
      inserted_at: user_role.inserted_at,
      updated_at: user_role.updated_at,
      deleted_at: user_role.deleted_at,
      inserted_by: user_role.inserted_by,
      updated_by: user_role.updated_by
    }
  end
end

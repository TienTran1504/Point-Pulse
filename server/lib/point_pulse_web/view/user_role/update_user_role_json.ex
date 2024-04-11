defmodule PointPulseWeb.UserRole.UpdateUserRoleJSON do
  alias PointPulse.UserRoles.UserRole

  def show(%{user_role: user_role}) do
    %{status: :OK, data: data(user_role)}
  end

  def show_message(%{message: message}) do
    %{status: :OK, message: message}
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

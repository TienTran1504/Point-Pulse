defmodule PointPulseWeb.User.CreateUserJSON do
  alias PointPulse.Users.User

  def show(%{user: user}) do
    %{status: :OK, data: data(user)}
  end

  def show_created_user(%{user: user, permissions: permissions}) do
    %{status: :OK, data: data_and_permissions(user, permissions)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      weight: user.weight,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at,
      deleted_at: user.deleted_at,
      inserted_by: user.inserted_by,
      updated_by: user.updated_by
    }
  end

  defp data_and_permissions(%User{} = user, permissions) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      weight: user.weight,
      permissions_created: permissions,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at,
      deleted_at: user.deleted_at,
      inserted_by: user.inserted_by,
      updated_by: user.updated_by
    }
  end
end

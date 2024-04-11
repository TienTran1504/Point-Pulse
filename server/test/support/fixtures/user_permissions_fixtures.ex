defmodule PointPulse.UserPermissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.UserPermissions` context.
  """

  @doc """
  Generate a user_permission.
  """
  def user_permission_fixture(attrs \\ %{}) do
    {:ok, user_permission} =
      attrs
      |> Enum.into(%{
        inserted_by: 42,
        permission_id: 42,
        updated_by: 42,
        user_id: 42
      })
      |> PointPulse.UserPermissions.create_user_permission()

    user_permission
  end
end

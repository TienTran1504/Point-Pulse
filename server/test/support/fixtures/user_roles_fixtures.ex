defmodule PointPulse.UserRolesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.UserRoles` context.
  """

  @doc """
  Generate a user_role.
  """
  def user_role_fixture(attrs \\ %{}) do
    {:ok, user_role} =
      attrs
      |> Enum.into(%{
        inserted_by: 42,
        name: "some name",
        updated_by: 42
      })
      |> PointPulse.UserRoles.create_user_role()

    user_role
  end
end

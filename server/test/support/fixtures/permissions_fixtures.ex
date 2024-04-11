defmodule PointPulse.PermissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.Permissions` context.
  """

  @doc """
  Generate a permission.
  """
  def permission_fixture(attrs \\ %{}) do
    {:ok, permission} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PointPulse.Permissions.create_permission()

    permission
  end
end

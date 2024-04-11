defmodule PointPulse.ProjectUsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.ProjectUsers` context.
  """

  @doc """
  Generate a project_user.
  """
  def project_user_fixture(attrs \\ %{}) do
    {:ok, project_user} =
      attrs
      |> Enum.into(%{
        inserted_by: 42,
        plan_point: 120.5,
        project_id: 42,
        updated_by: 42,
        user_id: 42,
        user_role_id: 42
      })
      |> PointPulse.ProjectUsers.create_project_user()

    project_user
  end
end

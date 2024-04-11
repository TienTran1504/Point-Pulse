defmodule PointPulse.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        inserted_by: 42,
        locked: true,
        name: "some name",
        plan_point: 120.5,
        type_id: 42,
        updated_by: 42
      })
      |> PointPulse.Projects.create_project()

    project
  end
end

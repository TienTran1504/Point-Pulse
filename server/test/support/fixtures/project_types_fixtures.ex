defmodule PointPulse.ProjectTypesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.ProjectTypes` context.
  """

  @doc """
  Generate a project_type.
  """
  def project_type_fixture(attrs \\ %{}) do
    {:ok, project_type} =
      attrs
      |> Enum.into(%{
        inserted_by: "some inserted_by",
        name: "some name",
        updated_by: "some updated_by"
      })
      |> PointPulse.ProjectTypes.create_project_type()

    project_type
  end
end

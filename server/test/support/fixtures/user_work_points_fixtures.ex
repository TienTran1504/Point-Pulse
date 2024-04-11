defmodule PointPulse.UserWorkPointsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.UserWorkPoints` context.
  """

  @doc """
  Generate a user_work_point.
  """
  def user_work_point_fixture(attrs \\ %{}) do
    {:ok, user_work_point} =
      attrs
      |> Enum.into(%{
        inserted_by: 42,
        month: 42,
        updated_by: 42,
        user_id: 42,
        week_of_year: 42,
        work_point: 120.5,
        year: 42
      })
      |> PointPulse.UserWorkPoints.create_user_work_point()

    user_work_point
  end
end

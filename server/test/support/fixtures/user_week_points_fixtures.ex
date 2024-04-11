defmodule PointPulse.UserWeekPointsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.UserWeekPoints` context.
  """

  @doc """
  Generate a user_week_point.
  """
  def user_week_point_fixture(attrs \\ %{}) do
    {:ok, user_week_point} =
      attrs
      |> Enum.into(%{
        actual_point: 120.5,
        inserted_by: 42,
        month: 42,
        plan_point: 120.5,
        project_id: 42,
        updated_by: 42,
        user_id: 42,
        week_of_year: 42,
        year: 42
      })
      |> PointPulse.UserWeekPoints.create_user_week_point()

    user_week_point
  end
end

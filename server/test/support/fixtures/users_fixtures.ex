defmodule PointPulse.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PointPulse.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        inserted_by: 42,
        name: "some name",
        password: "some password",
        updated_by: 42,
        weight: 120.5
      })
      |> PointPulse.Users.create_user()

    user
  end
end

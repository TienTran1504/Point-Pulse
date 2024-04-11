defmodule PointPulse.UserWeekPointsTest do
  use PointPulse.DataCase

  alias PointPulse.UserWeekPoints

  describe "user_week_points" do
    alias PointPulse.UserWeekPoints.UserWeekPoint

    import PointPulse.UserWeekPointsFixtures

    @invalid_attrs %{month: nil, year: nil, project_id: nil, user_id: nil, week_of_year: nil, plan_point: nil, actual_point: nil, inserted_by: nil, updated_by: nil}

    test "list_user_week_points/0 returns all user_week_points" do
      user_week_point = user_week_point_fixture()
      assert UserWeekPoints.list_user_week_points() == [user_week_point]
    end

    test "get_user_week_point!/1 returns the user_week_point with given id" do
      user_week_point = user_week_point_fixture()
      assert UserWeekPoints.get_user_week_point!(user_week_point.id) == user_week_point
    end

    test "create_user_week_point/1 with valid data creates a user_week_point" do
      valid_attrs = %{month: 42, year: 42, project_id: 42, user_id: 42, week_of_year: 42, plan_point: 120.5, actual_point: 120.5, inserted_by: 42, updated_by: 42}

      assert {:ok, %UserWeekPoint{} = user_week_point} = UserWeekPoints.create_user_week_point(valid_attrs)
      assert user_week_point.month == 42
      assert user_week_point.year == 42
      assert user_week_point.project_id == 42
      assert user_week_point.user_id == 42
      assert user_week_point.week_of_year == 42
      assert user_week_point.plan_point == 120.5
      assert user_week_point.actual_point == 120.5
      assert user_week_point.inserted_by == 42
      assert user_week_point.updated_by == 42
    end

    test "create_user_week_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserWeekPoints.create_user_week_point(@invalid_attrs)
    end

    test "update_user_week_point/2 with valid data updates the user_week_point" do
      user_week_point = user_week_point_fixture()
      update_attrs = %{month: 43, year: 43, project_id: 43, user_id: 43, week_of_year: 43, plan_point: 456.7, actual_point: 456.7, inserted_by: 43, updated_by: 43}

      assert {:ok, %UserWeekPoint{} = user_week_point} = UserWeekPoints.update_user_week_point(user_week_point, update_attrs)
      assert user_week_point.month == 43
      assert user_week_point.year == 43
      assert user_week_point.project_id == 43
      assert user_week_point.user_id == 43
      assert user_week_point.week_of_year == 43
      assert user_week_point.plan_point == 456.7
      assert user_week_point.actual_point == 456.7
      assert user_week_point.inserted_by == 43
      assert user_week_point.updated_by == 43
    end

    test "update_user_week_point/2 with invalid data returns error changeset" do
      user_week_point = user_week_point_fixture()
      assert {:error, %Ecto.Changeset{}} = UserWeekPoints.update_user_week_point(user_week_point, @invalid_attrs)
      assert user_week_point == UserWeekPoints.get_user_week_point!(user_week_point.id)
    end

    test "delete_user_week_point/1 deletes the user_week_point" do
      user_week_point = user_week_point_fixture()
      assert {:ok, %UserWeekPoint{}} = UserWeekPoints.delete_user_week_point(user_week_point)
      assert_raise Ecto.NoResultsError, fn -> UserWeekPoints.get_user_week_point!(user_week_point.id) end
    end

    test "change_user_week_point/1 returns a user_week_point changeset" do
      user_week_point = user_week_point_fixture()
      assert %Ecto.Changeset{} = UserWeekPoints.change_user_week_point(user_week_point)
    end
  end
end

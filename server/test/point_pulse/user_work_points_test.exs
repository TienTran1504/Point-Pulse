defmodule PointPulse.UserWorkPointsTest do
  use PointPulse.DataCase

  alias PointPulse.UserWorkPoints

  describe "user_work_points" do
    alias PointPulse.UserWorkPoints.UserWorkPoint

    import PointPulse.UserWorkPointsFixtures

    @invalid_attrs %{month: nil, year: nil, user_id: nil, week_of_year: nil, work_point: nil, inserted_by: nil, updated_by: nil}

    test "list_user_work_points/0 returns all user_work_points" do
      user_work_point = user_work_point_fixture()
      assert UserWorkPoints.list_user_work_points() == [user_work_point]
    end

    test "get_user_work_point!/1 returns the user_work_point with given id" do
      user_work_point = user_work_point_fixture()
      assert UserWorkPoints.get_user_work_point!(user_work_point.id) == user_work_point
    end

    test "create_user_work_point/1 with valid data creates a user_work_point" do
      valid_attrs = %{month: 42, year: 42, user_id: 42, week_of_year: 42, work_point: 120.5, inserted_by: 42, updated_by: 42}

      assert {:ok, %UserWorkPoint{} = user_work_point} = UserWorkPoints.create_user_work_point(valid_attrs)
      assert user_work_point.month == 42
      assert user_work_point.year == 42
      assert user_work_point.user_id == 42
      assert user_work_point.week_of_year == 42
      assert user_work_point.work_point == 120.5
      assert user_work_point.inserted_by == 42
      assert user_work_point.updated_by == 42
    end

    test "create_user_work_point/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserWorkPoints.create_user_work_point(@invalid_attrs)
    end

    test "update_user_work_point/2 with valid data updates the user_work_point" do
      user_work_point = user_work_point_fixture()
      update_attrs = %{month: 43, year: 43, user_id: 43, week_of_year: 43, work_point: 456.7, inserted_by: 43, updated_by: 43}

      assert {:ok, %UserWorkPoint{} = user_work_point} = UserWorkPoints.update_user_work_point(user_work_point, update_attrs)
      assert user_work_point.month == 43
      assert user_work_point.year == 43
      assert user_work_point.user_id == 43
      assert user_work_point.week_of_year == 43
      assert user_work_point.work_point == 456.7
      assert user_work_point.inserted_by == 43
      assert user_work_point.updated_by == 43
    end

    test "update_user_work_point/2 with invalid data returns error changeset" do
      user_work_point = user_work_point_fixture()
      assert {:error, %Ecto.Changeset{}} = UserWorkPoints.update_user_work_point(user_work_point, @invalid_attrs)
      assert user_work_point == UserWorkPoints.get_user_work_point!(user_work_point.id)
    end

    test "delete_user_work_point/1 deletes the user_work_point" do
      user_work_point = user_work_point_fixture()
      assert {:ok, %UserWorkPoint{}} = UserWorkPoints.delete_user_work_point(user_work_point)
      assert_raise Ecto.NoResultsError, fn -> UserWorkPoints.get_user_work_point!(user_work_point.id) end
    end

    test "change_user_work_point/1 returns a user_work_point changeset" do
      user_work_point = user_work_point_fixture()
      assert %Ecto.Changeset{} = UserWorkPoints.change_user_work_point(user_work_point)
    end
  end
end

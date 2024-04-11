defmodule PointPulse.ProjectUsersTest do
  use PointPulse.DataCase

  alias PointPulse.ProjectUsers

  describe "project_users" do
    alias PointPulse.ProjectUsers.ProjectUser

    import PointPulse.ProjectUsersFixtures

    @invalid_attrs %{project_id: nil, user_id: nil, user_role_id: nil, plan_point: nil, inserted_by: nil, updated_by: nil}

    test "list_project_users/0 returns all project_users" do
      project_user = project_user_fixture()
      assert ProjectUsers.list_project_users() == [project_user]
    end

    test "get_project_user!/1 returns the project_user with given id" do
      project_user = project_user_fixture()
      assert ProjectUsers.get_project_user!(project_user.id) == project_user
    end

    test "create_project_user/1 with valid data creates a project_user" do
      valid_attrs = %{project_id: 42, user_id: 42, user_role_id: 42, plan_point: 120.5, inserted_by: 42, updated_by: 42}

      assert {:ok, %ProjectUser{} = project_user} = ProjectUsers.create_project_user(valid_attrs)
      assert project_user.project_id == 42
      assert project_user.user_id == 42
      assert project_user.user_role_id == 42
      assert project_user.plan_point == 120.5
      assert project_user.inserted_by == 42
      assert project_user.updated_by == 42
    end

    test "create_project_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectUsers.create_project_user(@invalid_attrs)
    end

    test "update_project_user/2 with valid data updates the project_user" do
      project_user = project_user_fixture()
      update_attrs = %{project_id: 43, user_id: 43, user_role_id: 43, plan_point: 456.7, inserted_by: 43, updated_by: 43}

      assert {:ok, %ProjectUser{} = project_user} = ProjectUsers.update_project_user(project_user, update_attrs)
      assert project_user.project_id == 43
      assert project_user.user_id == 43
      assert project_user.user_role_id == 43
      assert project_user.plan_point == 456.7
      assert project_user.inserted_by == 43
      assert project_user.updated_by == 43
    end

    test "update_project_user/2 with invalid data returns error changeset" do
      project_user = project_user_fixture()
      assert {:error, %Ecto.Changeset{}} = ProjectUsers.update_project_user(project_user, @invalid_attrs)
      assert project_user == ProjectUsers.get_project_user!(project_user.id)
    end

    test "delete_project_user/1 deletes the project_user" do
      project_user = project_user_fixture()
      assert {:ok, %ProjectUser{}} = ProjectUsers.delete_project_user(project_user)
      assert_raise Ecto.NoResultsError, fn -> ProjectUsers.get_project_user!(project_user.id) end
    end

    test "change_project_user/1 returns a project_user changeset" do
      project_user = project_user_fixture()
      assert %Ecto.Changeset{} = ProjectUsers.change_project_user(project_user)
    end
  end
end

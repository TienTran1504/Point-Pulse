defmodule PointPulse.UserPermissionsTest do
  use PointPulse.DataCase

  alias PointPulse.UserPermissions

  describe "user_permissions" do
    alias PointPulse.UserPermissions.UserPermission

    import PointPulse.UserPermissionsFixtures

    @invalid_attrs %{user_id: nil, permission_id: nil, inserted_by: nil, updated_by: nil}

    test "list_user_permissions/0 returns all user_permissions" do
      user_permission = user_permission_fixture()
      assert UserPermissions.list_user_permissions() == [user_permission]
    end

    test "get_user_permission!/1 returns the user_permission with given id" do
      user_permission = user_permission_fixture()
      assert UserPermissions.get_user_permission!(user_permission.id) == user_permission
    end

    test "create_user_permission/1 with valid data creates a user_permission" do
      valid_attrs = %{user_id: 42, permission_id: 42, inserted_by: 42, updated_by: 42}

      assert {:ok, %UserPermission{} = user_permission} = UserPermissions.create_user_permission(valid_attrs)
      assert user_permission.user_id == 42
      assert user_permission.permission_id == 42
      assert user_permission.inserted_by == 42
      assert user_permission.updated_by == 42
    end

    test "create_user_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserPermissions.create_user_permission(@invalid_attrs)
    end

    test "update_user_permission/2 with valid data updates the user_permission" do
      user_permission = user_permission_fixture()
      update_attrs = %{user_id: 43, permission_id: 43, inserted_by: 43, updated_by: 43}

      assert {:ok, %UserPermission{} = user_permission} = UserPermissions.update_user_permission(user_permission, update_attrs)
      assert user_permission.user_id == 43
      assert user_permission.permission_id == 43
      assert user_permission.inserted_by == 43
      assert user_permission.updated_by == 43
    end

    test "update_user_permission/2 with invalid data returns error changeset" do
      user_permission = user_permission_fixture()
      assert {:error, %Ecto.Changeset{}} = UserPermissions.update_user_permission(user_permission, @invalid_attrs)
      assert user_permission == UserPermissions.get_user_permission!(user_permission.id)
    end

    test "delete_user_permission/1 deletes the user_permission" do
      user_permission = user_permission_fixture()
      assert {:ok, %UserPermission{}} = UserPermissions.delete_user_permission(user_permission)
      assert_raise Ecto.NoResultsError, fn -> UserPermissions.get_user_permission!(user_permission.id) end
    end

    test "change_user_permission/1 returns a user_permission changeset" do
      user_permission = user_permission_fixture()
      assert %Ecto.Changeset{} = UserPermissions.change_user_permission(user_permission)
    end
  end
end

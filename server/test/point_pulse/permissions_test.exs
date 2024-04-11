defmodule PointPulse.PermissionsTest do
  use PointPulse.DataCase

  alias PointPulse.Permissions

  describe "permissions" do
    alias PointPulse.Permissions.Permission

    import PointPulse.PermissionsFixtures

    @invalid_attrs %{name: nil}

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert Permissions.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert Permissions.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Permission{} = permission} = Permissions.create_permission(valid_attrs)
      assert permission.name == "some name"
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Permissions.create_permission(@invalid_attrs)
    end

    test "update_permission/2 with valid data updates the permission" do
      permission = permission_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Permission{} = permission} = Permissions.update_permission(permission, update_attrs)
      assert permission.name == "some updated name"
    end

    test "update_permission/2 with invalid data returns error changeset" do
      permission = permission_fixture()
      assert {:error, %Ecto.Changeset{}} = Permissions.update_permission(permission, @invalid_attrs)
      assert permission == Permissions.get_permission!(permission.id)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = Permissions.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = Permissions.change_permission(permission)
    end
  end
end

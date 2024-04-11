defmodule PointPulseWeb.UserPermissionControllerTest do
  use PointPulseWeb.ConnCase

  import PointPulse.UserPermissionsFixtures

  alias PointPulse.UserPermissions.UserPermission

  @create_attrs %{
    user_id: 42,
    permission_id: 42,
    inserted_by: 42,
    updated_by: 42
  }
  @update_attrs %{
    user_id: 43,
    permission_id: 43,
    inserted_by: 43,
    updated_by: 43
  }
  @invalid_attrs %{user_id: nil, permission_id: nil, inserted_by: nil, updated_by: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_permissions", %{conn: conn} do
      conn = get(conn, ~p"/api/user_permissions")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_permission" do
    test "renders user_permission when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_permissions", user_permission: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/user_permissions/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => 42,
               "permission_id" => 42,
               "updated_by" => 42,
               "user_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_permissions", user_permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_permission" do
    setup [:create_user_permission]

    test "renders user_permission when data is valid", %{conn: conn, user_permission: %UserPermission{id: id} = user_permission} do
      conn = put(conn, ~p"/api/user_permissions/#{user_permission}", user_permission: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/user_permissions/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => 43,
               "permission_id" => 43,
               "updated_by" => 43,
               "user_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_permission: user_permission} do
      conn = put(conn, ~p"/api/user_permissions/#{user_permission}", user_permission: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_permission" do
    setup [:create_user_permission]

    test "deletes chosen user_permission", %{conn: conn, user_permission: user_permission} do
      conn = delete(conn, ~p"/api/user_permissions/#{user_permission}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/user_permissions/#{user_permission}")
      end
    end
  end

  defp create_user_permission(_) do
    user_permission = user_permission_fixture()
    %{user_permission: user_permission}
  end
end

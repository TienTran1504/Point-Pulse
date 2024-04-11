defmodule PointPulseWeb.ProjectUserControllerTest do
  use PointPulseWeb.ConnCase

  import PointPulse.ProjectUsersFixtures

  alias PointPulse.ProjectUsers.ProjectUser

  @create_attrs %{
    project_id: 42,
    user_id: 42,
    user_role_id: 42,
    plan_point: 120.5,
    inserted_by: 42,
    updated_by: 42
  }
  @update_attrs %{
    project_id: 43,
    user_id: 43,
    user_role_id: 43,
    plan_point: 456.7,
    inserted_by: 43,
    updated_by: 43
  }
  @invalid_attrs %{project_id: nil, user_id: nil, user_role_id: nil, plan_point: nil, inserted_by: nil, updated_by: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all project_users", %{conn: conn} do
      conn = get(conn, ~p"/api/project_users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project_user" do
    test "renders project_user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/project_users", project_user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/project_users/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => 42,
               "plan_point" => 120.5,
               "project_id" => 42,
               "updated_by" => 42,
               "user_id" => 42,
               "user_role_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/project_users", project_user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project_user" do
    setup [:create_project_user]

    test "renders project_user when data is valid", %{conn: conn, project_user: %ProjectUser{id: id} = project_user} do
      conn = put(conn, ~p"/api/project_users/#{project_user}", project_user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/project_users/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => 43,
               "plan_point" => 456.7,
               "project_id" => 43,
               "updated_by" => 43,
               "user_id" => 43,
               "user_role_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project_user: project_user} do
      conn = put(conn, ~p"/api/project_users/#{project_user}", project_user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project_user" do
    setup [:create_project_user]

    test "deletes chosen project_user", %{conn: conn, project_user: project_user} do
      conn = delete(conn, ~p"/api/project_users/#{project_user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/project_users/#{project_user}")
      end
    end
  end

  defp create_project_user(_) do
    project_user = project_user_fixture()
    %{project_user: project_user}
  end
end

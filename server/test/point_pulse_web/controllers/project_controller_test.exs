defmodule PointPulseWeb.ProjectControllerTest do
  use PointPulseWeb.ConnCase

  import PointPulse.ProjectsFixtures

  alias PointPulse.Projects.Project

  @create_attrs %{
    name: "some name",
    type_id: 42,
    plan_point: 120.5,
    locked: true,
    inserted_by: 42,
    updated_by: 42
  }
  @update_attrs %{
    name: "some updated name",
    type_id: 43,
    plan_point: 456.7,
    locked: false,
    inserted_by: 43,
    updated_by: 43
  }
  @invalid_attrs %{name: nil, type_id: nil, plan_point: nil, locked: nil, inserted_by: nil, updated_by: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all projects", %{conn: conn} do
      conn = get(conn, ~p"/api/projects")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project" do
    test "renders project when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/projects", project: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/projects/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => 42,
               "locked" => true,
               "name" => "some name",
               "plan_point" => 120.5,
               "type_id" => 42,
               "updated_by" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/projects", project: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project" do
    setup [:create_project]

    test "renders project when data is valid", %{conn: conn, project: %Project{id: id} = project} do
      conn = put(conn, ~p"/api/projects/#{project}", project: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/projects/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => 43,
               "locked" => false,
               "name" => "some updated name",
               "plan_point" => 456.7,
               "type_id" => 43,
               "updated_by" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project: project} do
      conn = put(conn, ~p"/api/projects/#{project}", project: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project" do
    setup [:create_project]

    test "deletes chosen project", %{conn: conn, project: project} do
      conn = delete(conn, ~p"/api/projects/#{project}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/projects/#{project}")
      end
    end
  end

  defp create_project(_) do
    project = project_fixture()
    %{project: project}
  end
end

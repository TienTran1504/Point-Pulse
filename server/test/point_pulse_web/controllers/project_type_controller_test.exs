defmodule PointPulseWeb.ProjectTypeControllerTest do
  use PointPulseWeb.ConnCase

  import PointPulse.ProjectTypesFixtures

  alias PointPulse.ProjectTypes.ProjectType

  @create_attrs %{
    name: "some name",
    inserted_by: "some inserted_by",
    updated_by: "some updated_by"
  }
  @update_attrs %{
    name: "some updated name",
    inserted_by: "some updated inserted_by",
    updated_by: "some updated updated_by"
  }
  @invalid_attrs %{name: nil, inserted_by: nil, updated_by: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all project_types", %{conn: conn} do
      conn = get(conn, ~p"/api/project_types")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create project_type" do
    test "renders project_type when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/project_types", project_type: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/project_types/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => "some inserted_by",
               "name" => "some name",
               "updated_by" => "some updated_by"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/project_types", project_type: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update project_type" do
    setup [:create_project_type]

    test "renders project_type when data is valid", %{conn: conn, project_type: %ProjectType{id: id} = project_type} do
      conn = put(conn, ~p"/api/project_types/#{project_type}", project_type: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/project_types/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => "some updated inserted_by",
               "name" => "some updated name",
               "updated_by" => "some updated updated_by"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, project_type: project_type} do
      conn = put(conn, ~p"/api/project_types/#{project_type}", project_type: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete project_type" do
    setup [:create_project_type]

    test "deletes chosen project_type", %{conn: conn, project_type: project_type} do
      conn = delete(conn, ~p"/api/project_types/#{project_type}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/project_types/#{project_type}")
      end
    end
  end

  defp create_project_type(_) do
    project_type = project_type_fixture()
    %{project_type: project_type}
  end
end

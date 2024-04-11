defmodule PointPulseWeb.UserWorkPointControllerTest do
  use PointPulseWeb.ConnCase

  import PointPulse.UserWorkPointsFixtures

  alias PointPulse.UserWorkPoints.UserWorkPoint

  @create_attrs %{
    month: 42,
    year: 42,
    user_id: 42,
    week_of_year: 42,
    work_point: 120.5,
    inserted_by: 42,
    updated_by: 42
  }
  @update_attrs %{
    month: 43,
    year: 43,
    user_id: 43,
    week_of_year: 43,
    work_point: 456.7,
    inserted_by: 43,
    updated_by: 43
  }
  @invalid_attrs %{month: nil, year: nil, user_id: nil, week_of_year: nil, work_point: nil, inserted_by: nil, updated_by: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_work_points", %{conn: conn} do
      conn = get(conn, ~p"/api/user_work_points")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_work_point" do
    test "renders user_work_point when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_work_points", user_work_point: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/user_work_points/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => 42,
               "month" => 42,
               "updated_by" => 42,
               "user_id" => 42,
               "week_of_year" => 42,
               "work_point" => 120.5,
               "year" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_work_points", user_work_point: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_work_point" do
    setup [:create_user_work_point]

    test "renders user_work_point when data is valid", %{conn: conn, user_work_point: %UserWorkPoint{id: id} = user_work_point} do
      conn = put(conn, ~p"/api/user_work_points/#{user_work_point}", user_work_point: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/user_work_points/#{id}")

      assert %{
               "id" => ^id,
               "inserted_by" => 43,
               "month" => 43,
               "updated_by" => 43,
               "user_id" => 43,
               "week_of_year" => 43,
               "work_point" => 456.7,
               "year" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_work_point: user_work_point} do
      conn = put(conn, ~p"/api/user_work_points/#{user_work_point}", user_work_point: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_work_point" do
    setup [:create_user_work_point]

    test "deletes chosen user_work_point", %{conn: conn, user_work_point: user_work_point} do
      conn = delete(conn, ~p"/api/user_work_points/#{user_work_point}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/user_work_points/#{user_work_point}")
      end
    end
  end

  defp create_user_work_point(_) do
    user_work_point = user_work_point_fixture()
    %{user_work_point: user_work_point}
  end
end

defmodule PointPulseWeb.UserWeekPointControllerTest do
  use PointPulseWeb.ConnCase

  import PointPulse.UserWeekPointsFixtures

  alias PointPulse.UserWeekPoints.UserWeekPoint

  @create_attrs %{
    month: 42,
    year: 42,
    project_id: 42,
    user_id: 42,
    week_of_year: 42,
    plan_point: 120.5,
    actual_point: 120.5,
    inserted_by: 42,
    updated_by: 42
  }
  @update_attrs %{
    month: 43,
    year: 43,
    project_id: 43,
    user_id: 43,
    week_of_year: 43,
    plan_point: 456.7,
    actual_point: 456.7,
    inserted_by: 43,
    updated_by: 43
  }
  @invalid_attrs %{month: nil, year: nil, project_id: nil, user_id: nil, week_of_year: nil, plan_point: nil, actual_point: nil, inserted_by: nil, updated_by: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all user_week_points", %{conn: conn} do
      conn = get(conn, ~p"/api/user_week_points")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user_week_point" do
    test "renders user_week_point when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_week_points", user_week_point: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/user_week_points/#{id}")

      assert %{
               "id" => ^id,
               "actual_point" => 120.5,
               "inserted_by" => 42,
               "month" => 42,
               "plan_point" => 120.5,
               "project_id" => 42,
               "updated_by" => 42,
               "user_id" => 42,
               "week_of_year" => 42,
               "year" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/user_week_points", user_week_point: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user_week_point" do
    setup [:create_user_week_point]

    test "renders user_week_point when data is valid", %{conn: conn, user_week_point: %UserWeekPoint{id: id} = user_week_point} do
      conn = put(conn, ~p"/api/user_week_points/#{user_week_point}", user_week_point: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/user_week_points/#{id}")

      assert %{
               "id" => ^id,
               "actual_point" => 456.7,
               "inserted_by" => 43,
               "month" => 43,
               "plan_point" => 456.7,
               "project_id" => 43,
               "updated_by" => 43,
               "user_id" => 43,
               "week_of_year" => 43,
               "year" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user_week_point: user_week_point} do
      conn = put(conn, ~p"/api/user_week_points/#{user_week_point}", user_week_point: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user_week_point" do
    setup [:create_user_week_point]

    test "deletes chosen user_week_point", %{conn: conn, user_week_point: user_week_point} do
      conn = delete(conn, ~p"/api/user_week_points/#{user_week_point}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/user_week_points/#{user_week_point}")
      end
    end
  end

  defp create_user_week_point(_) do
    user_week_point = user_week_point_fixture()
    %{user_week_point: user_week_point}
  end
end

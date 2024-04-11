defmodule PointPulseWeb.UserWeekPointController do
  use PointPulseWeb, :controller

  alias PointPulse.UserWeekPoints
  alias PointPulse.UserWeekPoints.UserWeekPoint

  action_fallback PointPulseWeb.FallbackController

  def index(conn, _params) do
    user_week_points = UserWeekPoints.list_user_week_points()
    render(conn, :index, user_week_points: user_week_points)
  end

  def create(conn, %{"user_week_point" => user_week_point_params}) do
    with {:ok, %UserWeekPoint{} = user_week_point} <- UserWeekPoints.create_user_week_point(user_week_point_params) do
      conn
      |> put_status(:created)
      |> render(:show, user_week_point: user_week_point)
    end
  end

  def show(conn, %{"id" => id}) do
    user_week_point = UserWeekPoints.get_user_week_point!(id)
    render(conn, :show, user_week_point: user_week_point)
  end

  def update(conn, %{"id" => id, "user_week_point" => user_week_point_params}) do
    user_week_point = UserWeekPoints.get_user_week_point!(id)

    with {:ok, %UserWeekPoint{} = user_week_point} <- UserWeekPoints.update_user_week_point(user_week_point, user_week_point_params) do
      render(conn, :show, user_week_point: user_week_point)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_week_point = UserWeekPoints.get_user_week_point!(id)

    with {:ok, %UserWeekPoint{}} <- UserWeekPoints.delete_user_week_point(user_week_point) do
      send_resp(conn, :no_content, "")
    end
  end
end

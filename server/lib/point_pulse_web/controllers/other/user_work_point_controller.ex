defmodule PointPulseWeb.UserWorkPointController do
  use PointPulseWeb, :controller

  alias PointPulse.UserWorkPoints
  alias PointPulse.UserWorkPoints.UserWorkPoint

  action_fallback PointPulseWeb.FallbackController

  def index(conn, _params) do
    user_work_points = UserWorkPoints.list_user_work_points()
    render(conn, :index, user_work_points: user_work_points)
  end

  def create(conn, %{"user_work_point" => user_work_point_params}) do
    with {:ok, %UserWorkPoint{} = user_work_point} <- UserWorkPoints.create_user_work_point(user_work_point_params) do
      conn
      |> put_status(:created)
      |> render(:show, user_work_point: user_work_point)
    end
  end

  def show(conn, %{"id" => id}) do
    user_work_point = UserWorkPoints.get_user_work_point!(id)
    render(conn, :show, user_work_point: user_work_point)
  end

  def update(conn, %{"id" => id, "user_work_point" => user_work_point_params}) do
    user_work_point = UserWorkPoints.get_user_work_point!(id)

    with {:ok, %UserWorkPoint{} = user_work_point} <- UserWorkPoints.update_user_work_point(user_work_point, user_work_point_params) do
      render(conn, :show, user_work_point: user_work_point)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_work_point = UserWorkPoints.get_user_work_point!(id)

    with {:ok, %UserWorkPoint{}} <- UserWorkPoints.delete_user_work_point(user_work_point) do
      send_resp(conn, :no_content, "")
    end
  end
end

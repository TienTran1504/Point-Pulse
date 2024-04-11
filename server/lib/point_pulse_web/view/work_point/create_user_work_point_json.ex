defmodule PointPulseWeb.UserWorkPoint.CreateUserWorkPointJSON do
  alias PointPulse.UserWorkPoints.UserWorkPoint

  def show(%{user_work_point: user_work_point}) do
    %{status: :OK, data: data(user_work_point)}
  end

  def show_message(%{message: message}) do
    %{status: :BAD_REQUEST, message: message}
  end

  defp data(%UserWorkPoint{} = user_work_point) do
    %{
      id: user_work_point.id,
      user_id: user_work_point.user_id,
      year: user_work_point.year,
      week_of_year: user_work_point.week_of_year,
      month: user_work_point.month,
      work_point: user_work_point.work_point,
      inserted_at: user_work_point.inserted_at,
      updated_at: user_work_point.updated_at,
      inserted_by: user_work_point.inserted_by,
      updated_by: user_work_point.updated_by,
      title: "Thêm work point người dùng thành công!",
      icon: "success"
    }
  end
end

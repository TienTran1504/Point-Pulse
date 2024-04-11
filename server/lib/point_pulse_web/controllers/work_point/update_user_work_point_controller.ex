defmodule PointPulseWeb.UserWorkPoint.UpdateUserWorkPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWorkPoints
  alias PointPulse.UserWorkPoints.UserWorkPoint
  alias PointPulse.Utils.CalculateDate

  action_fallback PointPulseWeb.FallbackController

  @api_param_update_user_work_point %{
    user_id: [
      type: :integer,
      required: true
    ],
    time: [
      type: :string,
      required: true
    ],
    work_point: [
      type: :float,
      required: true
    ]
  }
  def update(conn, user_work_point_params) do
    user_work_point_params =
      @api_param_update_user_work_point
      |> Validator.parse(user_work_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_work_point_params.time)

    user_work_point_params =
      user_work_point_params
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    case UserWorkPoints.get_user_work_point_by_time!(
           user_work_point_params.user_id,
           user_work_point_params.year,
           user_work_point_params.week_of_year
         ) do
      nil ->
        render(conn, :show_message, message: "Don't have work point to update")

      user_work_point ->
        with {:ok, %UserWorkPoint{} = new_user_work_point} <-
               UserWorkPoints.update_user_work_point_with_metadata(
                 conn.assigns.user.id,
                 user_work_point,
                 user_work_point_params
               ) do
          render(conn, :show, user_work_point: new_user_work_point)
        end
    end
  end
end

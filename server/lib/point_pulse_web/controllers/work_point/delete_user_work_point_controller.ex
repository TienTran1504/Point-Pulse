defmodule PointPulseWeb.UserWorkPoint.DeleteUserWorkPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWorkPoints
  alias PointPulse.UserWorkPoints.UserWorkPoint
  alias PointPulse.Utils.CalculateDate

  action_fallback PointPulseWeb.FallbackController

  @api_param_delete_user_work_point %{
    user_id: [
      type: :integer,
      required: true
    ],
    time: [
      type: :string,
      required: true
    ]
  }

  def delete(conn, user_work_point_params) do
    user_work_point_params =
      @api_param_delete_user_work_point
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
        render(conn, :show_message, message: "Don't have work point to delete")

      user_work_point ->
        with {:ok, %UserWorkPoint{}} <- UserWorkPoints.delete_user_work_point(user_work_point) do
          render(conn, :show_message,
            message:
              "Deleted work point of user ID #{user_work_point_params.user_id} in week #{user_work_point_params.week_of_year} of #{user_work_point_params.year}"
          )
        end
    end
  end
end

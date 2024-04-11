defmodule PointPulseWeb.UserWeekPoint.DeleteUserWeekPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.UserWeekPoints.UserWeekPoint
  alias PointPulse.Utils.CalculateDate

  action_fallback PointPulseWeb.FallbackController

  @api_param_delete_user_week_point %{
    project_id: [
      type: :integer,
      required: true
    ],
    user_id: [
      type: :integer,
      required: true
    ],
    time: [
      type: :string,
      required: true
    ]
  }

  def delete(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_delete_user_week_point
      |> Validator.parse(user_week_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_week_point_params.time)

    user_week_point_params =
      user_week_point_params
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    case UserWeekPoints.get_user_week_point_by_time!(
           user_week_point_params.project_id,
           user_week_point_params.user_id,
           user_week_point_params.year,
           user_week_point_params.week_of_year
         ) do
      nil ->
        render(conn, :show_message, message: "Don't have week point to delete")

      user_week_point ->
        with {:ok, %UserWeekPoint{}} <- UserWeekPoints.delete_user_week_point(user_week_point) do
          render(conn, :show_message,
            message:
              "Deleted work point of user ID #{user_week_point_params.user_id} in week #{user_week_point_params.week_of_year} of #{user_week_point_params.year}"
          )
        end
    end
  end
end

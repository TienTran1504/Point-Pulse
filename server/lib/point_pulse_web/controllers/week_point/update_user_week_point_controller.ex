defmodule PointPulseWeb.UserWeekPoint.UpdateUserWeekPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.UserWeekPoints.UserWeekPoint
  alias PointPulse.Utils.CalculateDate

  action_fallback PointPulseWeb.FallbackController

  @api_param_update_user_week_point %{
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
    ],
    plan_point: [
      type: :float,
      number: [
        {:greater_than_or_equal_to, 0}
      ],
      required: true
    ],
    actual_point: [
      type: :float,
      number: [
        {:greater_than_or_equal_to, 0}
      ],
      required: true
    ]
  }
  def update(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_update_user_week_point
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
        render(conn, :show_message, message: "Don't have week point to update")

      user_week_point ->
        with {:ok, %UserWeekPoint{} = new_user_week_point} <-
               UserWeekPoints.update_user_week_point_with_metadata(
                 conn.assigns.user.id,
                 user_week_point,
                 user_week_point_params
               ) do
          render(conn, :show, user_week_point: new_user_week_point)
        end
    end
  end
end

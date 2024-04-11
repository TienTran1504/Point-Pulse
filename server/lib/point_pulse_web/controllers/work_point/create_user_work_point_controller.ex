defmodule PointPulseWeb.UserWorkPoint.CreateUserWorkPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWorkPoints
  alias PointPulse.UserWorkPoints.UserWorkPoint
  alias PointPulse.Utils.CalculateDate

  action_fallback PointPulseWeb.FallbackController

  @api_param_create_user_work_point %{
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
      number: [
        {:greater_than_or_equal_to, 0}
      ],
      required: true
    ]
  }

  def insert_work_point(conn, user_work_point_params) do
    user_work_point_params =
      @api_param_create_user_work_point
      |> Validator.parse(user_work_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_work_point_params.time)

    user_work_point_params =
      user_work_point_params
      |> Map.put(:month, week_infor.month)
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    case UserWorkPoints.get_user_work_point_by_time!(
           user_work_point_params.user_id,
           week_infor.year,
           week_infor.week
         ) do
      nil ->
        with {:ok, %UserWorkPoint{} = user_work_point} <-
               UserWorkPoints.create_user_work_point_with_metadata(
                 conn.assigns.user.id,
                 user_work_point_params
               ) do
          conn
          |> put_status(:created)
          |> render(:show, user_work_point: user_work_point)
        end

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

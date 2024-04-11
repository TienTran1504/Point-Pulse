defmodule PointPulseWeb.UserWorkPoint.GetUserWorkPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWorkPoints
  alias PointPulse.Utils.CalculateDate

  action_fallback PointPulseWeb.FallbackController

  @api_param_get_user_work_points %{
    time: [
      type: :string,
      required: true
    ]
  }
  @api_param_get_user_work_points_by_week_paginated %{
    time: [
      type: :string,
      required: true
    ],
    page: [
      type: :integer,
      number: [
        {:greater_than, 0}
      ],
      required: true
    ],
    page_size: [
      type: :integer,
      number: [
        {:greater_than, 0}
      ],
      required: true
    ]
  }

  @api_param_get_user_work_point %{
    user_id: [
      type: :integer,
      required: true
    ],
    time: [
      type: :string,
      required: true
    ]
  }

  def show_list_by_month(conn, user_work_point_params) do
    user_work_point_params =
      @api_param_get_user_work_points
      |> Validator.parse(user_work_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_work_point_params.time)

    user_work_point_params =
      user_work_point_params
      |> Map.put(:month, week_infor.month)
      |> Map.put(:year, week_infor.year)

    user_work_points =
      UserWorkPoints.list_user_work_points_by_month(
        user_work_point_params.year,
        user_work_point_params.month
      )

    render(conn, :show_list, user_work_points: user_work_points)
  end

  def show_list_by_week(conn, user_work_point_params) do
    user_work_point_params =
      @api_param_get_user_work_points
      |> Validator.parse(user_work_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_work_point_params.time)

    user_work_point_params =
      user_work_point_params
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    user_work_points =
      UserWorkPoints.list_user_work_points_by_week(
        user_work_point_params.year,
        user_work_point_params.week_of_year
      )

    render(conn, :show_list, user_work_points: user_work_points)
  end

  def show_list_by_week_paginated(conn, user_work_point_params) do
    user_work_point_params =
      @api_param_get_user_work_points_by_week_paginated
      |> Validator.parse(user_work_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_work_point_params.time)

    user_work_point_params =
      user_work_point_params
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    user_work_points =
      UserWorkPoints.list_user_work_points_by_week_and_paginate(
        user_work_point_params.year,
        user_work_point_params.week_of_year,
        user_work_point_params.page,
        user_work_point_params.page_size
      )

    render(conn, :show_list, user_work_points: user_work_points)
  end

  def show_user_work_point_by_week(conn, user_work_point_params) do
    user_work_point_params =
      @api_param_get_user_work_point
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
        render(conn, :show_message, message: "User does not have work point for this week")

      user_work_point ->
        render(conn, :show, user_work_point: user_work_point)
    end
  end
end

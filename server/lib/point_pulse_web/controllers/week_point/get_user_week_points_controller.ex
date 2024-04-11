defmodule PointPulseWeb.UserWeekPoint.GetUserWeekPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.Utils.CalculateDate

  action_fallback PointPulseWeb.FallbackController

  @api_param_get_user_week_points %{
    time: [
      type: :string,
      required: true
    ]
  }

  @api_param_get_user_week_points_by_week_paginated %{
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

  @api_param_get_user_week_point %{
    user_id: [
      type: :integer,
      required: true
    ],
    time: [
      type: :string,
      required: true
    ]
  }

  @api_param_get_week_point %{
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

  def show_list_by_month(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_get_user_week_points
      |> Validator.parse(user_week_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_week_point_params.time)

    user_week_point_params =
      user_week_point_params
      |> Map.put(:month, week_infor.month)
      |> Map.put(:year, week_infor.year)

    user_week_points =
      UserWeekPoints.list_user_week_points_by_month(
        user_week_point_params.year,
        user_week_point_params.month
      )

    render(conn, :show_list, user_week_points: user_week_points)
  end

  def show_list_by_week(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_get_user_week_points
      |> Validator.parse(user_week_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_week_point_params.time)

    user_week_point_params =
      user_week_point_params
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    user_week_points =
      UserWeekPoints.list_user_week_points_by_week(
        user_week_point_params.year,
        user_week_point_params.week_of_year
      )

    render(conn, :show_list, user_week_points: user_week_points)
  end

  def show_personal_list_by_week(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_get_user_week_points
      |> Validator.parse(user_week_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_week_point_params.time)

    user_week_point_params =
      user_week_point_params
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    user_week_points =
      UserWeekPoints.list_personal_week_points_by_week(
        conn.assigns.user.id,
        user_week_point_params.year,
        user_week_point_params.week_of_year
      )

    render(conn, :show_list, user_week_points: user_week_points)
  end

  def show_list_by_week_paginated(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_get_user_week_points_by_week_paginated
      |> Validator.parse(user_week_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_week_point_params.time)

    user_week_point_params =
      user_week_point_params
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    user_week_points =
      UserWeekPoints.list_user_week_points_by_week_and_paginate(
        user_week_point_params.year,
        user_week_point_params.week_of_year,
        user_week_point_params.page,
        user_week_point_params.page_size
      )

    render(conn, :show_list, user_week_points: user_week_points)
  end

  def show_user_week_point_by_week(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_get_user_week_point
      |> Validator.parse(user_week_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_week_point_params.time)

    user_week_point_params =
      user_week_point_params
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    user_week_point =
      UserWeekPoints.get_user_week_point_by_time!(
        user_week_point_params.project_id,
        user_week_point_params.user_id,
        user_week_point_params.year,
        user_week_point_params.week_of_year
      )

    render(conn, :show, user_week_point: user_week_point)
  end

  def show_week_point(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_get_week_point
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
        render(conn, :show_message, message: "Don't have week point")

      user_week_point ->
        render(conn, :show, user_week_point: user_week_point)
    end
  end
end

defmodule PointPulseWeb.Statistic.GetStatisticWorkPointsController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.UserWorkPoints
  alias PointPulse.Users
  alias PointPulse.Utils.CalculateDate
  action_fallback(PointPulseWeb.FallbackController)

  @api_param_get_work_points_by_time %{
    users: [
      type: {:array, :integer},
      required: true
    ],
    start_time: [
      type: :string,
      required: true
    ],
    end_time: [
      type: :string,
      required: true
    ]
  }
  def statistic_work_points(conn, params) do
    params =
      @api_param_get_work_points_by_time
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    data =
      Enum.map(params.users, fn user ->
        infor = _show_statistic_user_work_point(user, params.start_time, params.end_time)
        infor
      end)

    render(conn, :show_work_points, %{data: data})
  end

  defp _show_statistic_user_work_point(user_id, start_time, end_time) do
    start_week_infor =
      CalculateDate.week_to_month_with_working_days(start_time)

    end_week_infor =
      CalculateDate.week_to_month_with_working_days(end_time)

    user_plan_points =
      UserWeekPoints.list_user_points_statistics(
        user_id,
        start_week_infor.week,
        start_week_infor.year,
        end_week_infor.week,
        end_week_infor.year
      )

    user_work_points =
      UserWorkPoints.list_user_points_statistics(
        user_id,
        start_week_infor.week,
        start_week_infor.year,
        end_week_infor.week,
        end_week_infor.year
      )

    total_plan_point =
      Enum.reduce(user_plan_points, 0, fn point, acc -> point.plan_point + acc end)

    total_work_point =
      Enum.reduce(user_work_points, 0, fn point, acc -> point.work_point + acc end)

    user = Users.get_user!(user_id)

    remaining =
      if total_work_point - total_plan_point > 0 do
        total_work_point - total_plan_point
      else
        0
      end

    %{
      user_id: user_id,
      name: user.name,
      start_time: start_time,
      end_time: end_time,
      plan_point: total_plan_point,
      work_point: total_work_point,
      remaining: remaining
    }
  end
end

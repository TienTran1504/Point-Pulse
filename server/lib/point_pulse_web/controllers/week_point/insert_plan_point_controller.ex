defmodule PointPulseWeb.UserWeekPoint.InsertPlanPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.Projects
  alias PointPulse.UserWeekPoints.UserWeekPoint
  alias PointPulse.ProjectUsers
  alias PointPulse.Utils.CalculateDate

  action_fallback(PointPulseWeb.FallbackController)

  @api_param_create_user_week_point %{
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
      ]
    ],
    actual_point: [
      type: :float,
      number: [
        {:greater_than_or_equal_to, 0}
      ]
    ],
    old_plan_point: [
      type: :float,
      number: [
        {:greater_than_or_equal_to, 0}
      ]
    ]
  }

  @api_param_insert_member_week_point %{
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
    ]
  }

  def insert_plan_point(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_create_user_week_point
      |> Validator.parse(user_week_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_week_point_params.time)

    user_week_point_params =
      user_week_point_params
      |> Map.put(:month, week_infor.month)
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    case Projects.get_project!(user_week_point_params.project_id) do
      nil ->
        render(conn, :show_message, message: "Don't have project to insert week point")

      project ->
        case project.locked do
          true ->
            render(conn, :show_message, message: "The project has been locked")

          false ->
            case ProjectUsers.has_user_in_project?(
                   user_week_point_params.project_id,
                   user_week_point_params.user_id
                 ) do
              false ->
                render(conn, :show_message, message: "User has not joined in this project yet")

              true ->
                case UserWeekPoints.get_user_week_point_by_time!(
                       user_week_point_params.project_id,
                       user_week_point_params.user_id,
                       user_week_point_params.year,
                       user_week_point_params.week_of_year
                     ) do
                  nil ->
                    with {:ok, %UserWeekPoint{} = user_week_point} <-
                           UserWeekPoints.create_user_week_point_with_metadata(
                             conn.assigns.user.id,
                             Map.put_new(user_week_point_params, :plan_point, 0)
                             |> Map.put_new(:actual_point, 0)
                           ) do
                      conn
                      |> put_status(:created)
                      |> render(:show, user_week_point: user_week_point)
                    end

                  user_week_point ->
                    user_week_point_params =
                      user_week_point_params
                      |> Map.put_new(:old_plan_point, 0)
                      |> Map.put_new(:plan_point, 0)
                      |> Map.put_new(:actual_point, user_week_point.actual_point)

                    if user_week_point_params.old_plan_point == user_week_point.plan_point do
                      with {:ok, %UserWeekPoint{} = new_user_week_point} <-
                             UserWeekPoints.update_user_week_point_with_metadata(
                               conn.assigns.user.id,
                               user_week_point,
                               user_week_point_params
                             ) do
                        render(conn, :show, user_week_point: new_user_week_point)
                      end
                    else
                      infor_point =
                        Map.new()
                        |> Map.put(:user_id, user_week_point_params.user_id)
                        |> Map.put(:project_id, user_week_point_params.project_id)
                        |> Map.put(:year, user_week_point_params.year)
                        |> Map.put(:week_of_year, user_week_point_params.week_of_year)
                        |> Map.put(:plan_point, user_week_point.plan_point)
                        |> Map.put(:actual_point, user_week_point.actual_point)
                        |> Map.put(:new_plan_point, user_week_point_params.plan_point)

                      render(conn, :show_warning, infor_point: infor_point)
                    end
                end
            end
        end
    end
  end

  def insert_force_plan_point(conn, user_week_point_params) do
    user_week_point_params =
      @api_param_insert_member_week_point
      |> Validator.parse(user_week_point_params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(user_week_point_params.time)

    user_week_point_params =
      user_week_point_params
      |> Map.put(:month, week_infor.month)
      |> Map.put(:year, week_infor.year)
      |> Map.put(:week_of_year, week_infor.week)

    user_week_point =
      UserWeekPoints.get_user_week_point_by_time!(
        user_week_point_params.project_id,
        user_week_point_params.user_id,
        user_week_point_params.year,
        user_week_point_params.week_of_year
      )

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

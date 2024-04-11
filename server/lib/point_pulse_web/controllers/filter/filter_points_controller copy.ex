defmodule PointPulseWeb.Filter.FilterPointsCopyController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.ProjectTypes
  alias PointPulse.ProjectUsers
  alias PointPulse.Users
  alias PointPulse.Utils.CalculateDate
  action_fallback(PointPulseWeb.FallbackController)

  @api_param_filter %{
    options_filter: [
      type: :map,
      required: true
    ]
  }

  @api_param_filter_operator %{
    opr: [
      type: :string,
      inclusion: ["<=", ">=", "=", "and", "or"],
      required: true
    ]
  }
  @api_param_filter_options_expression %{
    lopd: [
      type: :map,
      required: true
    ],
    opr: [
      type: :string,
      required: true,
      inclusion: ["<=", ">=", "=", "and", "or"]
    ],
    ropd: [
      type: :map,
      required: true
    ]
  }

  @api_param_filter_options_value %{
    lopd: [
      type: :string,
      required: true
    ],
    opr: [
      type: :string,
      required: true,
      inclusion: ["<=", ">=", "=", "and", "or"]
    ],
    ropd: [
      type: :string,
      required: true
    ]
  }

  def filter_data(conn, params) do
    %{options_filter: options_filter} =
      @api_param_filter
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    formatted_string = _convert_string(options_filter)
    IO.inspect(formatted_string)

    result =
      UserWeekPoints.list_user_week_points_dynamic("Project A")
      |> _group_by_project_name()
      |> IO.inspect()

    # %{lopd: sub_lopd, opr: sub_opr, ropd: sub_ropd} =
    #   @api_param_filter_options_expression
    #   |> Validator.parse(options_filter)
    #   |> Validator.get_validated_changes!()

    # %{lopd: start_date_lopd, opr: start_date_opr, ropd: start_date_ropd} =
    #   @api_param_filter_options_value
    #   |> Validator.parse(sub_lopd)
    #   |> Validator.get_validated_changes!()

    # %{lopd: end_date_lopd, opr: end_date_opr, ropd: end_date_ropd} =
    #   @api_param_filter_options_value
    #   |> Validator.parse(sub_ropd)
    #   |> Validator.get_validated_changes!()

    # list_dates = CalculateDate.get_dates_in_range(start_date_ropd, end_date_ropd)

    # points_list =
    #   Enum.reduce(list_dates, [], fn date_str, acc ->
    #     date = CalculateDate.week_to_month_with_working_days(date_str)

    #     points_for_date =
    #       UserWeekPoints.list_user_week_points_by_week(date.year, date.week) |> IO.inspect()

    #     points_for_date ++ acc
    #   end)
    #   |> IO.inspect()
  end

  defp _convert_string(%{"lopd" => lopd, "opr" => opr, "ropd" => ropd}) do
    lopd_str = if is_map(lopd), do: _convert_string(lopd), else: lopd
    ropd_str = if is_map(ropd), do: _convert_string(ropd), else: ropd

    "(" <> lopd_str <> opr <> ropd_str <> ")"
  end

  defp _group_by_project_name(user_week_points) do
    user_week_points
    |> Enum.group_by(& &1[:name])
    |> Enum.flat_map(&_group_users(&1))
  end

  defp _group_users({project_name, user_week_points}) do
    [
      %{
        id: hd(user_week_points)[:id],
        name: project_name,
        type: hd(user_week_points)[:type],
        users: Enum.map(user_week_points, &_group_user(&1))
      }
    ]
  end

  defp _group_user(user_week_point) do
    %{
      id: hd(user_week_point[:users])[:id],
      user_id: hd(user_week_point[:users])[:user_id],
      user_name: hd(user_week_point[:users])[:user_name],
      points: user_week_point[:points]
    }
  end
end

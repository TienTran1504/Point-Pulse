defmodule PointPulseWeb.Filter.FilterPointsController do
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

    # params = [
    #   %{
    #     "lopd" => "project_name",
    #     "opr" => "=",
    #     "ropd" => "Project A"
    #   },
    #   %{
    #     "lopd" => "start_date",
    #     "opr" => ">=",
    #     "ropd" => ~U[2023-01-01 00:00:00Z]
    #   }
    #   # %{
    #   #   "lopd" => "end_date",
    #   #   "opr" => "<=",
    #   #   "ropd" => ~U[2023-12-31 00:00:00Z]
    #   # }
    # ]

    params = %{
      "lopd" => %{
        "lopd" => %{
          "lopd" => "project_name",
          "opr" => "=",
          "ropd" => "Project A"
        },
        "opr" => "or",
        "ropd" => %{
          "lopd" => "project_name",
          "opr" => "=",
          "ropd" => "Project B"
        }
      },
      "opr" => "and",
      "ropd" => %{
        "lopd" => %{
          "lopd" => "start_date",
          "opr" => ">=",
          "ropd" => ~U[2023-01-01 00:00:00Z]
        },
        "opr" => "and",
        "ropd" => %{
          "lopd" => "end_date",
          "opr" => "<=",
          "ropd" => ~U[2023-12-31 00:00:00Z]
        }
      }
    }

    result =
      UserWeekPoints.list_user_week_points_dynamic(params)

      # |> _group_by_project_name()
      |> IO.inspect()
  end

  defp _convert_string(%{"lopd" => lopd, "opr" => opr, "ropd" => ropd}) do
    lopd_str = if is_map(lopd), do: _convert_string(lopd), else: lopd
    ropd_str = if is_map(ropd), do: _convert_string(ropd), else: ropd

    "(" <> lopd_str <> opr <> ropd_str <> ")"
  end

  defp _group_by_project_name(user_week_points) do
    user_week_points
    |> Enum.group_by(& &1[:name])
    |> Enum.map(&group_project(&1))
  end

  defp group_project({project_name, user_week_points}) do
    %{
      id: hd(user_week_points)[:project_id],
      name: project_name,
      type: hd(user_week_points)[:type],
      users: Enum.map(user_week_points, &group_user/1)
    }
  end

  defp group_user(user_week_point) do
    # IO.inspect(user_week_point, label: "Test 2")
    users = user_week_point[:users]
    # IO.inspect(Enum.at(users, 0), label: "Test")
    IO.inspect(Enum.at(users, 0)[:points], label: "Test 1")

    case users do
      nil ->
        %{
          id: nil,
          user_id: nil,
          user_name: nil,
          points: []
        }

      _ ->
        %{
          id: hd(users)[:user_id],
          user_id: hd(users)[:user_id],
          user_name: hd(users)[:user_name],
          points: Enum.map(Enum.at(users, 0)[:points], &format_point/1)
        }
    end
  end

  defp format_point(point) do
    %{
      id: point.id,
      project_id: point.project_id,
      user_id: point.user_id,
      year: point.year,
      week_of_year: point.week_of_year,
      month: point.month,
      plan_point: point.plan_point,
      actual_point: point.actual_point
    }
  end
end

defmodule PointPulseWeb.UserWeekPoint.CreateUserWeekPointController do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.Projects
  alias PointPulse.UserWeekPoints.UserWeekPoint
  alias PointPulse.ProjectUsers
  alias PointPulse.Utils.CalculateDate
  alias PointPulse.Utils.CompareTime

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
    ],
    old_actual_point: [
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
    ],
    actual_point: [
      type: :float,
      number: [
        {:greater_than_or_equal_to, 0}
      ],
      required: true
    ]
  }

  @api_param_insert_point %{
    project_id: [
      type: :integer,
      required: true
    ],
    user_id: [
      type: :integer,
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
    ],
    time: [
      type: :string,
      required: true
    ]
  }
  def insert_multiple_week_point(conn, params) do
    time = DateTime.truncate(DateTime.utc_now(), :second)
    [formatted_date, _time] = DateTime.to_string(time) |> String.split(" ")
    current_time = CalculateDate.week_to_month_with_working_days(formatted_date)

    data =
      Enum.map(params["data"], fn entry ->
        week_infor = CalculateDate.week_to_month_with_working_days(entry["time"])
        checked = CompareTime.is_lt?(current_time, week_infor)

        entry =
          @api_param_insert_point
          |> Validator.parse(entry)
          |> Validator.get_validated_changes!()

        updated_entry =
          entry
          |> Map.put(:week_of_year, week_infor.week)
          |> Map.put(:year, week_infor.year)
          |> Map.put(:month, week_infor.month)

        if checked do
          updated_entry
        else
          updated_entry = Map.put(updated_entry, :actual_point, 0.0)
          updated_entry
        end
      end)

    {existing_entries, new_entries} =
      Enum.reduce(data, {[], []}, fn entry, {existing, new} ->
        case UserWeekPoints.has_user_week_point_by_time?(
               entry.project_id,
               entry.user_id,
               entry.year,
               entry.week_of_year
             ) do
          false ->
            # Phần tử không tồn tại, thêm vào danh sách new
            {existing, new ++ [entry]}

          true ->
            # Phần tử đã tồn tại, thêm vào danh sách existing
            {existing ++ [entry], new}
        end
      end)

    new_entries =
      Enum.uniq_by(new_entries, &{&1.project_id, &1.user_id, &1.week_of_year, &1.year})

    if length(new_entries) > 0 do
      new_data =
        Enum.map(new_entries, fn entry ->
          updated_entry =
            entry
            |> Map.put(:inserted_at, time)
            |> Map.put(:inserted_by, conn.assigns.user.id)
            |> Map.drop([:time])

          updated_entry
        end)

      UserWeekPoints.insert_multiple_week_points(new_data)
    end

    if length(existing_entries) > 0 do
      new_data =
        Enum.map(existing_entries, fn entry ->
          updated_entry =
            entry
            |> Map.put(:updated_at, time)
            |> Map.put(:updated_by, conn.assigns.user.id)

          updated_entry
        end)

      for week_point_param <- new_data do
        _insert_point(conn, week_point_param)
      end
    end
  end

  defp _insert_point(conn, user_week_point_params) do
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

    case UserWeekPoints.get_user_week_point_by_time!(
           user_week_point_params.project_id,
           user_week_point_params.user_id,
           user_week_point_params.year,
           user_week_point_params.week_of_year
         ) do
      nil ->
        with {:ok, %UserWeekPoint{} = _user_week_point} <-
               UserWeekPoints.create_user_week_point_with_metadata(
                 conn.assigns.user.id,
                 user_week_point_params
               ) do
        end

      user_week_point ->
        with {:ok, %UserWeekPoint{} = _new_user_week_point} <-
               UserWeekPoints.update_user_week_point_with_metadata(
                 conn.assigns.user.id,
                 user_week_point,
                 user_week_point_params
               ) do
        end
    end
  end
end

defmodule PointPulseWeb.Import.ImportPoints do
  use PointPulseWeb, :controller
  alias PointPulse.UserWeekPoints
  alias PointPulse.Projects
  alias PointPulse.Projects.Project
  alias PointPulse.Users
  alias PointPulse.Users.User
  alias PointPulseWeb.Permission.CreateUserPermissionsController
  alias PointPulse.UserWeekPoints.UserWeekPoint
  alias PointPulse.ProjectUsers
  alias PointPulse.ProjectUsers.ProjectUser
  alias PointPulse.Utils.CalculateDate
  alias PointPulse.Utils.CompareTime

  action_fallback(PointPulseWeb.FallbackController)

  @api_param_import_points %{
    project_name: [
      type: :string,
      required: true
    ],
    user_name: [
      type: :string,
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
      ]
    ],
    actual_point: [
      type: :float,
      number: [
        {:greater_than_or_equal_to, 0}
      ]
    ]
  }

  def import_points(conn, params) do
    checked = _check_data_structure(params)

    if checked do
      time = DateTime.truncate(DateTime.utc_now(), :second)
      [formatted_date, _time] = DateTime.to_string(time) |> String.split(" ")
      current_time = CalculateDate.week_to_month_with_working_days(formatted_date)

      data =
        Enum.map(params["data"], fn entry ->
          week_infor = CalculateDate.week_to_month_with_working_days(entry["time"])
          checked = CompareTime.is_lt?(current_time, week_infor)

          entry =
            @api_param_import_points
            |> Validator.parse(entry)
            |> Validator.get_validated_changes!()

          infor = _handle_data(conn, entry, time)
          # Truyển user_id, project_id vào updated_entry và drop project_name và user_name
          updated_entry =
            entry
            |> Map.put(:week_of_year, week_infor.week)
            |> Map.put(:year, week_infor.year)
            |> Map.put(:month, week_infor.month)
            |> Map.put(:user_id, infor.user_id)
            |> Map.put(:project_id, infor.project_id)
            |> Map.drop([:project_name, :user_name])

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

      render(conn, :show)
    else
      render(conn, :import_error)
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

  defp _handle_data(conn, entry, time) do
    # Kiểm tra xem user đã được tạo chưa nếu chưa thì tạo
    case Users.has_user?(entry.user_name) do
      false ->
        user_params =
          Map.new()
          |> Map.put(:password, "123123")
          |> Map.put(:name, entry.user_name)
          |> Map.put(:weight, 1)

        with {:ok, %User{} = user} <-
               Users.create_user_with_metadata(conn.assigns.user.id, user_params) do
          CreateUserPermissionsController.create_permission(
            conn.assigns.user.id,
            user.id,
            []
          )
        end

      true ->
        nil
    end

    case Projects.has_project?(entry.project_name) do
      false ->
        project_params =
          Map.new()
          |> Map.put(:name, entry.project_name)
          |> Map.put(:type_id, 7)
          |> Map.put(:locked, false)
          |> Map.put(:start_date, time)
          |> Map.put(:end_date, time)

        with {:ok, %Project{} = _project} <-
               Projects.create_project_with_metadata(
                 conn.assigns.user.id,
                 project_params
               ) do
        end

      true ->
        nil
    end

    project = Projects.get_project_by_name(entry.project_name)
    user = Users.get_user_by_name(entry.user_name)

    case ProjectUsers.has_user_in_project?(project.id, user.id) do
      false ->
        project_user_params =
          Map.new()
          |> Map.put(:project_id, project.id)
          |> Map.put(:user_id, user.id)
          |> Map.put(:user_role_id, 1)

        with {:ok, %ProjectUser{} = _project_user} <-
               ProjectUsers.create_project_user_with_metadata(
                 conn.assigns.user.id,
                 project_user_params
               ) do
          nil
        end

      true ->
        nil
    end

    %{
      project_id: project.id,
      user_id: user.id
    }
  end

  defp _check_data_structure(data) do
    case data do
      %{"data" => list} when is_list(list) ->
        if Enum.all?(list, &_is_data_item/1) do
          true
        else
          false
        end

      _ ->
        false
    end
  end

  defp _is_data_item(item) do
    is_map(item) and
      Map.has_key?(item, "actual_point") and
      Map.has_key?(item, "plan_point") and
      Map.has_key?(item, "project_name") and
      Map.has_key?(item, "time") and
      Map.has_key?(item, "user_name") and
      _is_number_or_nil(Map.get(item, "actual_point")) and
      _is_number_or_nil(Map.get(item, "plan_point")) and
      _is_string(Map.get(item, "project_name")) and
      _is_string(Map.get(item, "time")) and
      _is_string(Map.get(item, "user_name"))
  end

  defp _is_number_or_nil(nil), do: true
  defp _is_number_or_nil(value) when is_number(value) and value >= 0, do: true
  defp _is_number_or_nil(_), do: false

  defp _is_string(nil), do: true
  defp _is_string(value) when is_binary(value), do: true
  defp _is_string(_), do: false
end

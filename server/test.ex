defmodule CalculateDate do
  def week_to_month_with_working_days(date_str) do
    date_of_week = _week_to_month(date_str)
    day_of_week = Date.day_of_week(date_of_week)
    first_day_of_week = Date.add(date_of_week, -day_of_week + 1)
    calculate_date = Date.add(first_day_of_week, 2)
    {year, month, day} = Date.to_erl(first_day_of_week)
    {calculate_year, calculate_month, calculate_day} = Date.to_erl(calculate_date)

    if month == calculate_month do
      week_of_year = _week_of_year(%{year: year, month: month, day: day})

      %{
        week: week_of_year,
        year: year,
        month: month
      }
    else
      week_of_year =
        _week_of_year(%{year: calculate_year, month: calculate_month, day: calculate_day})

      %{
        week: week_of_year,
        year: calculate_year,
        month: calculate_month
      }
    end
  end

  def _week_of_year(%{year: year, month: month, day: day}) do
    {:ok, first_day_of_year} = Date.new(year, 1, 1)
    {:ok, current_day} = Date.new(year, month, day)
    day_of_week = Date.day_of_week(first_day_of_year)
    first_day_of_year = Date.add(first_day_of_year, 1 - day_of_week)

    # day_diff = Date.diff(current_day, first_day_of_year)

    # if day_of_week > 3 do
    #   week_number = div(day_diff, 7) + 1
    #   week_number
    # else
    #   week_number = div(day_diff, 7) + 1
    #   week_number
    # end

    day_diff = Date.diff(current_day, first_day_of_year)

    week_number = div(day_diff, 7) + 1

    week_number
  end

  def _week_to_month(date_str) do
    # Parse the date string in the format "DD-MM-YYYY"
    [year, month, day] = String.split(date_str, "-") |> Enum.map(&String.to_integer/1)
    # Convert the date components to a Date object
    {:ok, date} = Date.new(year, month, day)
    date
  end
end

defmodule FilterConverter do
  def convert_filter(filter) do
    case filter do
      %{"lopd" => lopd, "opr" => opr, "ropd" => ropd} ->
        converted_lopd = convert_filter(lopd)
        converted_ropd = convert_filter(ropd)

        "(#{converted_lopd} #{opr} #{converted_ropd})"

      %{"lopd" => lopd, "opr" => opr, "ropd" => ropd} ->
        converted_lopd = convert_filter(lopd)
        converted_ropd = convert_filter(ropd)

        "(#{converted_lopd} #{opr} #{converted_ropd})"

      value ->
        value
    end
  end

  def construct_query(filter_data) do
    filter = filter_data[:options_filter]
    apply_filter(filter)
  end

  defp apply_filter(%{"lopd" => lopd, "opr" => opr, "ropd" => ropd}) do
    converted_lopd = apply_filter(lopd)
    converted_ropd = apply_filter(ropd)
    "(#{converted_lopd} #{opr} #{converted_ropd})"
  end

  defp apply_filter(%{"lopd" => lopd, "opr" => opr, "ropd" => ropd}) do
    converted_lopd = apply_filter(lopd)
    converted_ropd = apply_filter(ropd)
    "(#{converted_lopd} #{opr} #{converted_ropd})"
  end

  defp apply_filter(%{"opr" => "and", "lopd" => lopd, "ropd" => ropd}) do
    apply_filter(lopd) and apply_filter(ropd)
  end

  defp apply_filter(%{"opr" => "or", "lopd" => lopd, "ropd" => ropd}) do
    apply_filter(lopd) or apply_filter(ropd)
  end

  defp apply_filter(%{"opr" => opr, "lopd" => lopd, "ropd" => ropd}) do
    "(#{lopd} #{opr} #{ropd})"
  end

  # Default case when the filter structure is not recognized
  defp apply_filter(value), do: value
end

defmodule JsonToLogic do
  def json_to_logic(%{options_filter: options_filter}) do
    json_to_logic(options_filter)
  end

  def json_to_logic(%{lopd: lopd, opr: opr, ropd: ropd}) do
    left = json_to_logic(lopd)
    right = json_to_logic(ropd)

    case opr do
      "and" -> {:and, left, right}
      "or" -> {:or, left, right}
      _ -> {String.to_atom(opr), left, right}
    end
  end

  def json_to_logic(%{lopd: [], opr: opr, ropd: ropd}) do
    case {opr, ropd} do
      {_opr, nil} -> nil
      {opr, _} -> {String.to_atom(opr), nil, json_to_logic(ropd)}
    end
  end

  def json_to_logic(%{lopd: lopd, opr: opr, ropd: ropd}) do
    {String.to_atom(opr), json_to_logic(lopd), json_to_logic(ropd)}
  end

  def json_to_logic(%{lopd: _lopd, opr: _opr, ropd: _ropd} = value) do
    {lopd, opr, ropd} =
      Map.take(value, ~w(lopd opr ropd)a)
      |> Map.values()

    json_to_logic(%{lopd: lopd, opr: opr, ropd: ropd})
  end

  def json_to_logic(value) when is_list(value) do
    case value do
      [] -> nil
      _ -> Enum.map(value, &json_to_logic/1)
    end
  end

  def json_to_logic(value) when is_number(value) or is_binary(value) or is_atom(value), do: value
end

json_data_1 = %{
  options_filter: %{
    lopd: %{
      lopd: %{
        lopd: "start_date",
        opr: ">=",
        ropd: "2023-08-18"
      },
      opr: "and",
      ropd: %{
        lopd: "end_date",
        opr: "<=",
        ropd: "2023-10-20"
      }
    },
    opr: "and",
    ropd: %{
      lopd: %{
        lopd: "project_name",
        opr: "=",
        ropd: "Project A"
      },
      opr: "or",
      ropd: %{
        lopd: "project_name",
        opr: "=",
        ropd: "Project B"
      }
    }
  }
}

json_data_2 = %{
  options_filter: %{
    lopd: %{
      lopd: %{
        lopd: %{
          lopd: "start_date",
          opr: ">=",
          ropd: "2023-08-18"
        },
        opr: "and",
        ropd: %{
          lopd: "end_date",
          opr: "<=",
          ropd: "2023-10-20"
        }
      },
      opr: "and",
      ropd: %{
        lopd: %{
          lopd: "project_name",
          opr: "=",
          ropd: "Project A"
        },
        opr: "or",
        ropd: %{
          lopd: "project_name",
          opr: "=",
          ropd: "Project B"
        }
      }
    },
    opr: "and",
    ropd: %{
      lopd: %{
        lopd: "project_type",
        opr: "=",
        ropd: "client"
      },
      opr: "or",
      ropd: %{
        lopd: "project_type",
        opr: "=",
        ropd: "inner"
      }
    }
  }
}

result = JsonToLogic.json_to_logic(json_data_1) |> IO.inspect(label: "Result 1")
result2 = JsonToLogic.json_to_logic(json_data_2) |> IO.inspect(label: "Result 2")

# converted_filter = FilterConverter.convert_filter(filter_data["options_filter"]) |> IO.inspect()

# year = "2019"
# IO.inspect("-------------------------------1-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-01-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-30") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-01-31") |> IO.inspect()

# IO.inspect("-------------------------------2-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-02-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-02-28") |> IO.inspect()
# # CalculateDate.week_to_month_with_working_days(year <> "-02-29") |> IO.inspect()

# IO.inspect("-------------------------------3-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-03-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-30") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-03-31") |> IO.inspect()

# IO.inspect("-------------------------------4-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-04-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-04-30") |> IO.inspect()

# IO.inspect("-------------------------------5-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-05-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-30") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-05-31") |> IO.inspect()

# IO.inspect("-------------------------------6-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-06-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-06-30") |> IO.inspect()

# IO.inspect("-------------------------------7-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-07-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-30") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-07-31") |> IO.inspect()

# IO.inspect("-------------------------------8-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-08-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-30") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-08-31") |> IO.inspect()

# IO.inspect("-------------------------------9-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-09-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-09-30") |> IO.inspect()

# IO.inspect("-------------------------------10-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-10-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-30") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-10-31") |> IO.inspect()

# IO.inspect("-------------------------------11-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-11-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-11-30") |> IO.inspect()

# IO.inspect("-------------------------------12-------------------------------")
# CalculateDate.week_to_month_with_working_days(year <> "-12-01") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-02") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-03") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-04") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-05") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-06") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-07") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-08") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-09") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-10") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-11") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-12") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-13") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-14") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-15") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-16") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-17") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-18") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-19") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-20") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-21") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-22") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-23") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-24") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-25") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-26") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-27") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-28") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-29") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-30") |> IO.inspect()
# CalculateDate.week_to_month_with_working_days(year <> "-12-31") |> IO.inspect()

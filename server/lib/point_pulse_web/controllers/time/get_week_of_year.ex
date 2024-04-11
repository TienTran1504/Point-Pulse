defmodule PointPulseWeb.Time.GetWeekOfYearController do
  use PointPulseWeb, :controller
  alias PointPulse.Utils.CalculateDate
  action_fallback(PointPulseWeb.FallbackController)

  @api_param_get_week_of_year %{
    time: [
      type: :string,
      required: true
    ]
  }

  def show(conn, params) do
    params =
      @api_param_get_week_of_year
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    week_infor =
      CalculateDate.week_to_month_with_working_days(params.time)

    render(conn, :show, week_infor: week_infor)
  end
end

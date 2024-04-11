defmodule PointPulse.UserWeekPoints.UserWeekPoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_week_points" do
    belongs_to :project, PointPulse.Projects.Project
    belongs_to :user, PointPulse.Users.User
    field :year, :integer
    field :week_of_year, :integer
    field :month, :integer
    field :plan_point, :float, default: 0.0
    field :actual_point, :float, default: 0.0

    timestamps(type: :utc_datetime)

    field :inserted_by, :integer
    field :updated_by, :integer
  end

  @doc false
  def changeset(user_week_point, attrs) do
    user_week_point
    |> cast(attrs, [
      :project_id,
      :user_id,
      :year,
      :week_of_year,
      :month,
      :plan_point,
      :actual_point,
      :inserted_by,
      :updated_by
    ])
  end
end

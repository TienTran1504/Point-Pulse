defmodule PointPulse.UserWorkPoints.UserWorkPoint do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_work_points" do
    belongs_to :user, PointPulse.Users.User
    field :year, :integer
    field :week_of_year, :integer
    field :month, :integer
    field :work_point, :float, default: 0.0

    timestamps(type: :utc_datetime)

    field :inserted_by, :integer
    field :updated_by, :integer
  end

  @doc false
  def changeset(user_work_point, attrs) do
    user_work_point
    |> cast(attrs, [
      :user_id,
      :year,
      :week_of_year,
      :month,
      :work_point,
      :inserted_by,
      :updated_by
    ])
  end
end

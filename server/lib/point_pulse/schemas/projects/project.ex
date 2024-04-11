defmodule PointPulse.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string

    belongs_to :project_type, PointPulse.ProjectTypes.ProjectType, foreign_key: :type_id
    field :locked, :boolean, default: false

    field :start_date, :date, default: nil
    field :end_date, :date, default: nil
    timestamps(type: :utc_datetime)
    field :deleted_at, :utc_datetime, default: nil

    field :inserted_by, :integer
    field :updated_by, :integer

    has_many :project_users, PointPulse.ProjectUsers.ProjectUser
    has_many :user_week_points, PointPulse.UserWeekPoints.UserWeekPoint
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [
      :name,
      :type_id,
      :locked,
      :start_date,
      :end_date,
      :deleted_at,
      :inserted_by,
      :updated_by
    ])
  end
end

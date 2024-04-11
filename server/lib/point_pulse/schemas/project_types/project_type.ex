defmodule PointPulse.ProjectTypes.ProjectType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_types" do
    field :name, :string

    timestamps(type: :utc_datetime)
    field :deleted_at, :utc_datetime, default: nil

    field :inserted_by, :integer
    field :updated_by, :integer

    has_many :projects, PointPulse.Projects.Project, foreign_key: :type_id
  end

  @doc false
  def changeset(project_type, attrs) do
    project_type
    |> cast(attrs, [:name, :deleted_at, :inserted_by, :updated_by])
  end
end

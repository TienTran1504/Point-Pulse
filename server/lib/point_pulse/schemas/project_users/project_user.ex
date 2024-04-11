defmodule PointPulse.ProjectUsers.ProjectUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "project_users" do
    belongs_to :project, PointPulse.Projects.Project
    belongs_to :user, PointPulse.Users.User
    belongs_to :user_role, PointPulse.UserRoles.UserRole

    timestamps(type: :utc_datetime)
    field :inserted_by, :integer
    field :updated_by, :integer
  end

  @doc false
  def changeset(project_user, attrs) do
    project_user
    |> cast(attrs, [:project_id, :user_id, :user_role_id, :inserted_by, :updated_by])
  end
end

defmodule PointPulse.UserRoles.UserRole do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_roles" do
    field :name, :string

    timestamps(type: :utc_datetime)
    field :deleted_at, :utc_datetime, default: nil

    field :inserted_by, :integer
    field :updated_by, :integer

    has_many :project_users, PointPulse.ProjectUsers.ProjectUser, foreign_key: :user_role_id
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:name, :deleted_at, :inserted_by, :updated_by])
  end
end

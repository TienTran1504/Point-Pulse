defmodule PointPulse.UserPermissions.UserPermission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_permissions" do
    belongs_to :user, PointPulse.Users.User
    belongs_to :permission, PointPulse.Permissions.Permission

    timestamps(type: :utc_datetime)
    field :deleted_at, :utc_datetime, default: nil

    field :inserted_by, :integer
    field :updated_by, :integer
  end

  @doc false
  def changeset(user_permission, attrs) do
    user_permission
    |> cast(attrs, [:user_id, :permission_id, :deleted_at, :inserted_by, :updated_by])
  end
end

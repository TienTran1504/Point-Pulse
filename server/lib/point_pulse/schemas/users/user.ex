defmodule PointPulse.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :weight, :float

    timestamps(type: :utc_datetime, precision: 6)
    field :deleted_at, :utc_datetime, default: nil

    field :inserted_by, :integer
    field :updated_by, :integer

    has_many :user_permissions, PointPulse.UserPermissions.UserPermission, foreign_key: :user_id
    has_many :project_users, PointPulse.ProjectUsers.ProjectUser, foreign_key: :user_id
    has_many :user_week_points, PointPulse.UserWeekPoints.UserWeekPoint, foreign_key: :user_id
    has_many :user_work_points, PointPulse.UserWorkPoints.UserWorkPoint, foreign_key: :user_id
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :weight, :deleted_at, :inserted_by, :updated_by])
    |> validate_required([:name, :password, :weight])
    |> unique_constraint(:email)
    |> _put_password_hash()
  end

  defp _put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp _put_password_hash(changeset), do: changeset
end

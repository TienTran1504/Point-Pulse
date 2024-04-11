defmodule PointPulse.Repo.Migrations.CreateUserPermissions do
  use Ecto.Migration

  def change do
    create table(:user_permissions) do
      add :user_id, references(:users, on_delete: :nilify_all)
      add :permission_id, references(:permissions, on_delete: :nilify_all)
      add :inserted_at, :naive_datetime, default: fragment("CURRENT_TIMESTAMP"), null: false
      add :updated_at, :naive_datetime, default: nil, on_update: fragment("CURRENT_TIMESTAMP")
      add :deleted_at, :naive_datetime, default: nil
      add :inserted_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
      add :updated_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
    end
  end
end

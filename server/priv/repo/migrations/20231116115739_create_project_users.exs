defmodule PointPulse.Repo.Migrations.CreateProjectUsers do
  use Ecto.Migration

  def change do
    create table(:project_users) do
      add :project_id, references(:projects, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :user_role_id, references(:user_roles, on_delete: :nilify_all)
      add :inserted_at, :naive_datetime, default: fragment("CURRENT_TIMESTAMP"), null: false
      add :updated_at, :naive_datetime, default: nil, on_update: fragment("CURRENT_TIMESTAMP")
      add :inserted_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
      add :updated_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
    end
  end
end

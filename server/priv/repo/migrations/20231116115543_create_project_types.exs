defmodule PointPulse.Repo.Migrations.CreateProjectTypes do
  use Ecto.Migration

  def change do
    create table(:project_types) do
      add :name, :string, null: false
      add :inserted_at, :naive_datetime, default: fragment("CURRENT_TIMESTAMP"), null: false
      add :updated_at, :naive_datetime, default: nil, on_update: fragment("CURRENT_TIMESTAMP")
      add :deleted_at, :naive_datetime, default: nil
      add :inserted_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
      add :updated_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
    end
  end
end

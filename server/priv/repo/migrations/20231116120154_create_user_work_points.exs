defmodule PointPulse.Repo.Migrations.CreateUserWorkPoints do
  use Ecto.Migration

  def change do
    create table(:user_work_points) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :year, :integer, null: false
      add :week_of_year, :integer, null: false
      add :month, :integer, null: false
      add :work_point, :float, default: 0.0
      add :inserted_at, :naive_datetime, default: fragment("CURRENT_TIMESTAMP"), null: false
      add :updated_at, :naive_datetime, default: nil, on_update: fragment("CURRENT_TIMESTAMP")
      add :inserted_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
      add :updated_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
    end
  end
end

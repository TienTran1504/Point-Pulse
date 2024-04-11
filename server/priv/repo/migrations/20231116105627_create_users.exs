defmodule PointPulse.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, default: nil, unique: true
      add :password, :string, null: false
      add :weight, :float, default: 0.0, check: "weight >= 0 AND weight <= 1"
      add :inserted_at, :naive_datetime, default: fragment("CURRENT_TIMESTAMP"), null: false
      add :updated_at, :naive_datetime, default: nil, on_update: fragment("CURRENT_TIMESTAMP")
      add :deleted_at, :naive_datetime, default: nil
      add :inserted_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
      add :updated_by, references(:users, column: :id, on_delete: :nilify_all), default: nil
    end

    create index(:users, [:email], unique: true)
  end
end

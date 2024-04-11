defmodule PointPulse.Repo.Migrations.CreatePermissions do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :name, :string

      timestamps(type: :utc_datetime)
    end
  end
end

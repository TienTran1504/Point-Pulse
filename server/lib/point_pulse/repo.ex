defmodule PointPulse.Repo do
  # alias PointPulse.RepoError

  use Ecto.Repo,
    otp_app: :point_pulse,
    adapter: Ecto.Adapters.MyXQL

  use Scrivener

  def insert_with_metadata(changeset, %{user_id: user_id}) do
    time = DateTime.truncate(DateTime.utc_now(), :second)

    changeset
    |> Ecto.Changeset.put_change(:inserted_at, time)
    |> Ecto.Changeset.put_change(:inserted_by, user_id)
    |> insert()
  end

  # def insert_all_with_metadata(changeset, %{user_id: user_id}) do
  #   time = DateTime.truncate(DateTime.utc_now(), :second)

  #   changeset
  #   |> Ecto.Changeset.put_change(:inserted_at, time)
  #   |> Ecto.Changeset.put_change(:inserted_by, user_id)
  #   |> insert()
  # end

  def update_with_metadata(changeset, %{user_id: user_id}) do
    time = DateTime.truncate(DateTime.utc_now(), :second)

    changeset
    |> Ecto.Changeset.put_change(:updated_at, time)
    |> Ecto.Changeset.put_change(:updated_by, user_id)
    |> update()
  end

  # K cho overwrite
  # def insert(changeset, %{user_id: user_id} \\ %{}) do
  #   time = DateTime.truncate(DateTime.utc_now(), :second)

  #   changeset
  #   |> Ecto.Changeset.put_change(:inserted_at, time)
  #   |> Ecto.Changeset.put_change(:inserted_by, user_id)
  #   |> insert()
  # end

  # # Thêm một mẫu hàm insert/2 không có user_id để đối phó với trường hợp user_id không được cung cấp.
  # def insert(changeset, _params) do
  #   time = DateTime.truncate(DateTime.utc_now(), :second)

  #   changeset
  #   |> Ecto.Changeset.put_change(:inserted_at, time)
  #   |> insert()
  # end

  # def insert(_changeset, _) do
  #   raise RepoError.BadRequest
  # end

  # def update(changeset, %{user_id: user_id}) do
  #   time = DateTime.truncate(DateTime.utc_now(), :second)

  #   changeset
  #   |> Ecto.Changeset.put_change(:updated_at, time)
  #   |> Ecto.Changeset.put_change(:updated_by, user_id)
  #   |> update(%{user_id: user_id})
  # end

  # def update(_changeset, _) do
  #   raise RepoError.BadRequest
  # end
end

defmodule PointPulse.UserPermissions do
  @moduledoc """
  The UserPermissions context.
  """

  import Ecto.Query, warn: false
  alias PointPulse.Repo

  alias PointPulse.UserPermissions.UserPermission

  @doc """
  Returns the list of user_permissions.

  ## Examples

      iex> list_user_permissions()
      [%UserPermission{}, ...]

  """
  def list_user_permissions do
    Repo.all(UserPermission)
  end

  def get_user_permissions_by_id!(user_id, permission_id) do
    UserPermission
    |> where([user], user.user_id == ^user_id and user.permission_id == ^permission_id)
    |> Repo.one()
  end

  @doc """
  Gets a single user_permission.

  Raises `Ecto.NoResultsError` if the User permission does not exist.

  ## Examples

      iex> get_user_permission!(123)
      %UserPermission{}

      iex> get_user_permission!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_permission!(id), do: Repo.get!(UserPermission, id)

  def get_person_permissions(user_id) do
    UserPermission
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  @doc """
  Creates a user_permission.

  ## Examples

      iex> create_user_permission(%{field: value})
      {:ok, %UserPermission{}}

      iex> create_user_permission(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_user_permission(attrs \\ %{}) do
    %UserPermission{}
    |> UserPermission.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_permission_with_metadata(user_id, attrs \\ %{}) do
    %UserPermission{}
    |> UserPermission.changeset(attrs)
    |> Repo.insert_with_metadata(%{user_id: user_id})
  end

  def preload_permission(user_permissions) do
    Repo.preload(user_permissions, [:permission])
  end

  @doc """
  Updates a user_permission.

  ## Examples

      iex> update_user_permission(user_permission, %{field: new_value})
      {:ok, %UserPermission{}}

      iex> update_user_permission(user_permission, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_permission(%UserPermission{} = user_permission, attrs) do
    user_permission
    |> UserPermission.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_permission.

  ## Examples

      iex> delete_user_permission(user_permission)
      {:ok, %UserPermission{}}

      iex> delete_user_permission(user_permission)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_permission(%UserPermission{} = user_permission) do
    Repo.delete(user_permission)
  end

  def delete_user_permissions(user_id) do
    UserPermission
    |> where([user], user.user_id == ^user_id and user.permission_id != 5)
    |> Repo.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_permission changes.

  ## Examples

      iex> change_user_permission(user_permission)
      %Ecto.Changeset{data: %UserPermission{}}

  """
  def change_user_permission(%UserPermission{} = user_permission, attrs \\ %{}) do
    UserPermission.changeset(user_permission, attrs)
  end
end

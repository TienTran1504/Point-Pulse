defmodule PointPulse.UserRoles do
  @moduledoc """
  The UserRoles context.
  """

  import Ecto.Query, warn: false
  alias PointPulse.Repo

  alias PointPulse.UserRoles.UserRole

  @doc """
  Returns the list of user_roles.

  ## Examples

      iex> list_user_roles()
      [%UserRole{}, ...]

  """
  def list_user_roles do
    Repo.all(UserRole)
  end

  def list_user_roles_exist do
    UserRole
    |> where([user_role], is_nil(user_role.deleted_at))
    |> Repo.all()
  end

  def list_user_roles_exist_and_paginate(page, page_size) do
    UserRole
    |> where([user_role], is_nil(user_role.deleted_at))
    |> Repo.all()
    |> Repo.paginate(page: page, page_size: page_size)
  end

  @doc """
  Gets a single user_role.

  Raises `Ecto.NoResultsError` if the User role does not exist.

  ## Examples

      iex> get_user_role!(123)
      %UserRole{}

      iex> get_user_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_role!(id), do: Repo.get!(UserRole, id)

  def get_user_role_by_name!(name) do
    UserRole
    |> where([user_role], user_role.name == ^name and is_nil(user_role.deleted_at))
    |> Repo.one()
  end

  def has_user_role?(name) do
    UserRole
    |> where([user_role], user_role.name == ^name and is_nil(user_role.deleted_at))
    |> Repo.exists?()
  end

  @doc """
  Creates a user_role.

  ## Examples

      iex> create_user_role(%{field: value})
      {:ok, %UserRole{}}

      iex> create_user_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_role(attrs \\ %{}) do
    %UserRole{}
    |> UserRole.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_role_with_metadata(user_id, attrs \\ %{}) do
    %UserRole{}
    |> UserRole.changeset(attrs)
    |> Repo.insert_with_metadata(%{user_id: user_id})
  end

  @doc """
  Updates a user_role.

  ## Examples

      iex> update_user_role(user_role, %{field: new_value})
      {:ok, %UserRole{}}

      iex> update_user_role(user_role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_role(%UserRole{} = user_role, attrs) do
    user_role
    |> UserRole.changeset(attrs)
    |> Repo.update()
  end

  def update_user_role_with_metadata(user_id, %UserRole{} = user_role, attrs) do
    user_role
    |> UserRole.changeset(attrs)
    |> Repo.update_with_metadata(%{user_id: user_id})
  end

  @doc """
  Deletes a user_role.

  ## Examples

      iex> delete_user_role(user_role)
      {:ok, %UserRole{}}

      iex> delete_user_role(user_role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_role(%UserRole{} = user_role) do
    Repo.delete(user_role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_role changes.

  ## Examples

      iex> change_user_role(user_role)
      %Ecto.Changeset{data: %UserRole{}}

  """
  def change_user_role(%UserRole{} = user_role, attrs \\ %{}) do
    UserRole.changeset(user_role, attrs)
  end
end

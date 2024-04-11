defmodule PointPulse.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias PointPulse.Repo

  alias PointPulse.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_users_exist do
    User
    |> where([user], is_nil(user.deleted_at))
    |> Repo.all()
  end

  def list_users_exist_and_paginate(page, page_size) do
    User
    |> where([user], is_nil(user.deleted_at))
    |> Repo.all()
    |> Repo.paginate(page: page, page_size: page_size)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
  end

  @doc """
  Get a single user.any()

  Return nil if the user does not exist
  Examples:
  iex> get_user_by_email(noaccount@gmail.com)
  nil
  """

  def get_user_by_email(email) do
    User
    |> where(email: ^email)
    |> Repo.one()
  end

  def get_user_by_name(name) do
    User
    |> where(name: ^name)
    |> Repo.one()
  end

  def has_user?(name) do
    User
    |> where(
      [user],
      user.name == ^name
    )
    |> Repo.exists?()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_with_metadata(user_id, attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert_with_metadata(%{user_id: user_id})
  end

  def preload_user(user) do
    Repo.preload(user, [:user])
  end

  def preload_user_permissions(user) do
    user
    |> Repo.preload([:user_permissions])
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user_with_metadata(user_id, %User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update_with_metadata(%{user_id: user_id})
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end

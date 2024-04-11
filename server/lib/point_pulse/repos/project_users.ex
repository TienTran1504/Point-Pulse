defmodule PointPulse.ProjectUsers do
  @moduledoc """
  The ProjectUsers context.
  """

  import Ecto.Query, warn: false
  alias PointPulse.Repo

  alias PointPulse.ProjectUsers.ProjectUser

  @doc """
  Returns the list of project_users.

  ## Examples

      iex> list_project_users()
      [%ProjectUser{}, ...]

  """
  def list_project_users do
    Repo.all(ProjectUser)
  end

  def list_users_in_project(project_id) do
    ProjectUser
    |> where(project_id: ^project_id)
    |> Repo.all()
  end

  def list_projects_user_joined(user_id) do
    ProjectUser
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def preload_user_and_project(project_users) do
    project_users
    |> Repo.preload([:user, :project])
  end

  def preload_user(project_users) do
    project_users
    |> Repo.preload([:user, :user_role])
  end

  def list_project_users_and_paginate(project_id, page, page_size) do
    ProjectUser
    |> where(project_id: ^project_id)
    |> Repo.all()
    |> Repo.preload([:user, :user_role])
    |> Repo.paginate(page: page, page_size: page_size)
  end

  def preload_project_user(project_users) do
    project_users
    |> Repo.preload([:user, :user_role])
  end

  @doc """
  Gets a single project_user.

  Raises `Ecto.NoResultsError` if the Project user does not exist.

  ## Examples

      iex> get_project_user!(123)
      %ProjectUser{}

      iex> get_project_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_user!(id), do: Repo.get!(ProjectUser, id)

  def get_user_in_project!(project_id, user_id) do
    ProjectUser
    |> where(
      [project_user],
      project_user.user_id == ^user_id and project_user.project_id == ^project_id
    )
    |> Repo.one()
    |> Repo.preload([:user_role])
  end

  def has_user_in_project?(project_id, user_id) do
    ProjectUser
    |> where(
      [project_user],
      project_user.user_id == ^user_id and project_user.project_id == ^project_id
    )
    |> Repo.exists?()
  end

  @doc """
  Creates a project_user.

  ## Examples

      iex> create_project_user(%{field: value})
      {:ok, %ProjectUser{}}

      iex> create_project_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_user(attrs \\ %{}) do
    %ProjectUser{}
    |> ProjectUser.changeset(attrs)
    |> Repo.insert()
  end

  def create_project_user_with_metadata(user_id, attrs \\ %{}) do
    %ProjectUser{}
    |> ProjectUser.changeset(attrs)
    |> Repo.insert_with_metadata(%{user_id: user_id})
  end

  @doc """
  Updates a project_user.

  ## Examples

      iex> update_project_user(project_user, %{field: new_value})
      {:ok, %ProjectUser{}}

      iex> update_project_user(project_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_user(%ProjectUser{} = project_user, attrs) do
    project_user
    |> ProjectUser.changeset(attrs)
    |> Repo.update()
  end

  def update_project_user_with_metadata(user_id, %ProjectUser{} = project_user, attrs) do
    project_user
    |> ProjectUser.changeset(attrs)
    |> Repo.update_with_metadata(%{user_id: user_id})
  end

  @doc """
  Deletes a project_user.

  ## Examples

      iex> delete_project_user(project_user)
      {:ok, %ProjectUser{}}

      iex> delete_project_user(project_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_user(%ProjectUser{} = project_user) do
    Repo.delete(project_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_user changes.

  ## Examples

      iex> change_project_user(project_user)
      %Ecto.Changeset{data: %ProjectUser{}}

  """
  def change_project_user(%ProjectUser{} = project_user, attrs \\ %{}) do
    ProjectUser.changeset(project_user, attrs)
  end
end

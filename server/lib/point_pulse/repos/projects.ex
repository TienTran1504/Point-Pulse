defmodule PointPulse.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias PointPulse.Repo

  alias PointPulse.Projects.Project

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

  def list_projects_exist do
    Project
    |> where([project], is_nil(project.deleted_at))
    |> Repo.all()
  end

  def list_projects_exist_and_unblocked do
    Project
    |> where([project], is_nil(project.deleted_at) and project.locked == false)
    |> Repo.all()
  end

  def list_projects_exist_and_paginate(page, page_size) do
    Project
    |> where([project], is_nil(project.deleted_at))
    |> Repo.all()
    |> Repo.preload([:project_type])
    |> Repo.paginate(page: page, page_size: page_size)
  end

  def preload_project_type(projects) do
    projects
    |> Repo.preload([:project_type])
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  def get_project_by_name(name) do
    Project
    |> where(name: ^name)
    |> Repo.one()
  end

  def has_project?(name) do
    Project
    |> where(
      [project],
      project.name == ^name
    )
    |> Repo.exists?()
  end

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  def create_project_with_metadata(user_id, attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert_with_metadata(%{user_id: user_id})
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  def update_project_with_metadata(user_id, %Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update_with_metadata(%{user_id: user_id})
  end

  @doc """
  Deletes a project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{data: %Project{}}

  """
  def change_project(%Project{} = project, attrs \\ %{}) do
    Project.changeset(project, attrs)
  end
end

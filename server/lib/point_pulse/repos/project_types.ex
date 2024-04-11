defmodule PointPulse.ProjectTypes do
  @moduledoc """
  The ProjectTypes context.
  """

  import Ecto.Query, warn: false
  alias PointPulse.Repo

  alias PointPulse.ProjectTypes.ProjectType

  @doc """
  Returns the list of project_types.

  ## Examples

      iex> list_project_types()
      [%ProjectType{}, ...]

  """
  def list_project_types do
    Repo.all(ProjectType)
  end

  def list_project_types_exist do
    ProjectType
    |> where([project_type], is_nil(project_type.deleted_at))
    |> Repo.all()
  end

  def list_project_types_exist_and_paginate(page, page_size) do
    ProjectType
    |> where([project_type], is_nil(project_type.deleted_at))
    |> Repo.all()
    |> Repo.paginate(page: page, page_size: page_size)
  end

  @doc """
  Gets a single project_type.

  Raises `Ecto.NoResultsError` if the Project type does not exist.

  ## Examples

      iex> get_project_type!(123)
      %ProjectType{}

      iex> get_project_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_type!(id), do: Repo.get!(ProjectType, id)

  def get_project_type_by_name!(name) do
    ProjectType
    |> where([project_type], project_type.name == ^name and is_nil(project_type.deleted_at))
    |> Repo.one()
  end

  def has_project_type_name?(name) do
    ProjectType
    |> where([project_type], project_type.name == ^name and is_nil(project_type.deleted_at))
    |> Repo.exists?()
  end

  @doc """
  Creates a project_type.

  ## Examples

      iex> create_project_type(%{field: value})
      {:ok, %ProjectType{}}

      iex> create_project_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_type(attrs \\ %{}) do
    %ProjectType{}
    |> ProjectType.changeset(attrs)
    |> Repo.insert()
  end

  def create_project_type_with_metadata(user_id, attrs \\ %{}) do
    %ProjectType{}
    |> ProjectType.changeset(attrs)
    |> Repo.insert_with_metadata(%{user_id: user_id})
  end

  @doc """
  Updates a project_type.

  ## Examples

      iex> update_project_type(project_type, %{field: new_value})
      {:ok, %ProjectType{}}

      iex> update_project_type(project_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_type(%ProjectType{} = project_type, attrs) do
    project_type
    |> ProjectType.changeset(attrs)
    |> Repo.update()
  end

  def update_project_type_with_metadata(user_id, %ProjectType{} = project_type, attrs) do
    project_type
    |> ProjectType.changeset(attrs)
    |> Repo.update_with_metadata(%{user_id: user_id})
  end

  @doc """
  Deletes a project_type.

  ## Examples

      iex> delete_project_type(project_type)
      {:ok, %ProjectType{}}

      iex> delete_project_type(project_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_type(%ProjectType{} = project_type) do
    Repo.delete(project_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_type changes.

  ## Examples

      iex> change_project_type(project_type)
      %Ecto.Changeset{data: %ProjectType{}}

  """
  def change_project_type(%ProjectType{} = project_type, attrs \\ %{}) do
    ProjectType.changeset(project_type, attrs)
  end
end

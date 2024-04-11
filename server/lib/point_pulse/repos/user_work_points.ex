defmodule PointPulse.UserWorkPoints do
  @moduledoc """
  The UserWorkPoints context.
  """

  import Ecto.Query, warn: false
  alias PointPulse.Repo

  alias PointPulse.UserWorkPoints.UserWorkPoint

  @doc """
  Returns the list of user_work_points.

  ## Examples

      iex> list_user_work_points()
      [%UserWorkPoint{}, ...]

  """
  def list_user_work_points do
    Repo.all(UserWorkPoint)
  end

  def list_user_points_statistics(user_id, start_week, start_year, end_week, end_year) do
    UserWorkPoint
    |> where(
      [user_work_point],
      user_work_point.user_id == ^user_id and
        ((user_work_point.year == ^start_year and user_work_point.week_of_year >= ^start_week) or
           user_work_point.year > ^start_year) and
        ((user_work_point.year == ^end_year and user_work_point.week_of_year <= ^end_week) or
           user_work_point.year < ^end_year)
    )
    |> Repo.all()
  end

  def list_user_work_points_by_month(year, month) do
    UserWorkPoint
    |> where([user_work_point], user_work_point.year == ^year and user_work_point.month == ^month)
    |> Repo.all()
  end

  def list_user_work_points_by_week(year, week) do
    UserWorkPoint
    |> where(
      [user_work_point],
      user_work_point.year == ^year and user_work_point.week_of_year == ^week
    )
    |> Repo.all()
  end

  def list_user_work_points_by_week_and_paginate(year, week, page, page_size) do
    UserWorkPoint
    |> where(
      [user_work_point],
      user_work_point.year == ^year and user_work_point.week_of_year == ^week
    )
    |> Repo.all()
    |> Repo.paginate(page: page, page_size: page_size)
  end

  @doc """
  Gets a single user_work_point.

  Raises `Ecto.NoResultsError` if the User work point does not exist.

  ## Examples

      iex> get_user_work_point!(123)
      %UserWorkPoint{}

      iex> get_user_work_point!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_work_point!(id), do: Repo.get!(UserWorkPoint, id)

  def get_user_work_point_by_time!(user_id, year, week) do
    UserWorkPoint
    |> where(
      [user_work_point],
      user_work_point.user_id == ^user_id and user_work_point.year == ^year and
        user_work_point.week_of_year == ^week
    )
    |> Repo.one()
  end

  def has_user_work_point?(user_id, year, week) do
    UserWorkPoint
    |> where(
      [user_work_point],
      user_work_point.user_id == ^user_id and user_work_point.year == ^year and
        user_work_point.week_of_year == ^week
    )
    |> Repo.exists?()
  end

  @doc """
  Creates a user_work_point.

  ## Examples

      iex> create_user_work_point(%{field: value})
      {:ok, %UserWorkPoint{}}

      iex> create_user_work_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_work_point(attrs \\ %{}) do
    %UserWorkPoint{}
    |> UserWorkPoint.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_work_point_with_metadata(user_id, attrs \\ %{}) do
    %UserWorkPoint{}
    |> UserWorkPoint.changeset(attrs)
    |> Repo.insert_with_metadata(%{user_id: user_id})
  end

  @doc """
  Updates a user_work_point.

  ## Examples

      iex> update_user_work_point(user_work_point, %{field: new_value})
      {:ok, %UserWorkPoint{}}

      iex> update_user_work_point(user_work_point, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_work_point(%UserWorkPoint{} = user_work_point, attrs) do
    user_work_point
    |> UserWorkPoint.changeset(attrs)
    |> Repo.update()
  end

  def update_user_work_point_with_metadata(user_id, %UserWorkPoint{} = user_work_point, attrs) do
    user_work_point
    |> UserWorkPoint.changeset(attrs)
    |> Repo.update_with_metadata(%{user_id: user_id})
  end

  @doc """
  Deletes a user_work_point.

  ## Examples

      iex> delete_user_work_point(user_work_point)
      {:ok, %UserWorkPoint{}}

      iex> delete_user_work_point(user_work_point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_work_point(%UserWorkPoint{} = user_work_point) do
    Repo.delete(user_work_point)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_work_point changes.

  ## Examples

      iex> change_user_work_point(user_work_point)
      %Ecto.Changeset{data: %UserWorkPoint{}}

  """
  def change_user_work_point(%UserWorkPoint{} = user_work_point, attrs \\ %{}) do
    UserWorkPoint.changeset(user_work_point, attrs)
  end
end

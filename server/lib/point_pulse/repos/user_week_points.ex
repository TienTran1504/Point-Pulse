defmodule PointPulse.UserWeekPoints do
  @moduledoc """
  The UserWeekPoints context.
  """

  import Ecto.Query, warn: false
  alias PointPulse.Repo

  alias PointPulse.UserWeekPoints.UserWeekPoint
  alias PointPulse.Projects.Project
  alias PointPulse.ProjectTypes.ProjectType
  alias PointPulse.ProjectUsers.ProjectUser
  alias PointPulse.Users.User

  @doc """
  Returns the list of user_week_points.

  ## Examples

      iex> list_user_week_points()
      [%UserWeekPoint{}, ...]

  """
  def list_user_week_points do
    Repo.all(UserWeekPoint)
  end

  def list_project_points_by_month(project_id, month, year) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.project_id == ^project_id and user_week_point.month == ^month and
        user_week_point.year == ^year
    )
    |> Repo.all()
  end

  def list_all_projects_points_by_month(month, year) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.month == ^month and
        user_week_point.year == ^year
    )
    |> Repo.all()
  end

  def list_project_points_statistics(project_id, start_week, start_year, end_week, end_year) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.project_id == ^project_id and
        ((user_week_point.year == ^start_year and user_week_point.week_of_year >= ^start_week) or
           user_week_point.year > ^start_year) and
        ((user_week_point.year == ^end_year and user_week_point.week_of_year <= ^end_week) or
           user_week_point.year < ^end_year)
    )
    |> Repo.all()
  end

  def list_user_points_by_month(user_id, month, year) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.user_id == ^user_id and user_week_point.month == ^month and
        user_week_point.year == ^year
    )
    |> Repo.all()
  end

  def list_user_points_statistics(user_id, start_week, start_year, end_week, end_year) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.user_id == ^user_id and
        ((user_week_point.year == ^start_year and user_week_point.week_of_year >= ^start_week) or
           user_week_point.year > ^start_year) and
        ((user_week_point.year == ^end_year and user_week_point.week_of_year <= ^end_week) or
           user_week_point.year < ^end_year)
    )
    |> Repo.all()
  end

  def list_user_week_points_in_project(project_id, user_id) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.project_id == ^project_id and user_week_point.user_id == ^user_id
    )
    |> Repo.all()
  end

  def preload_user(user_week_points) do
    user_week_points
    |> Repo.preload([:user])
  end

  def preload_project(user_week_points) do
    user_week_points
    |> Repo.preload([:project])
  end

  def list_member_week_points_in_project(project_id) do
    UserWeekPoint
    |> where([user_week_point], user_week_point.project_id == ^project_id)
    |> Repo.all()
  end

  def list_user_week_points_by_month(year, month) do
    UserWeekPoint
    |> where([user_week_point], user_week_point.year == ^year and user_week_point.month == ^month)
    |> Repo.all()
  end

  def list_user_week_points_by_week(year, week) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.year == ^year and user_week_point.week_of_year == ^week
    )
    |> Repo.all()
  end

  def handle_filter(acc, opr, lopd, ropd, field) do
    case opr do
      "=" ->
        dynamic([p], ^acc and field(p, ^field) == ^ropd)

      ">=" ->
        dynamic([p], ^acc and field(p, ^field) >= ^ropd)

      "<=" ->
        dynamic([p], ^acc and field(p, ^field) <= ^ropd)

      "<" ->
        dynamic([p], ^acc and field(p, ^field) < ^ropd)

      ">" ->
        dynamic([p], ^acc and field(p, ^field) > ^ropd)

      "!=" ->
        dynamic([p], ^acc and field(p, ^field) != ^ropd)

      "and" ->
        dynamic_func(acc, lopd) and dynamic_func(acc, ropd)

      "or" ->
        dynamic_func(acc, lopd) or dynamic_func(acc, ropd)
    end
  end

  def handle_expression(lopd, opr, ropd) do
    case opr do
      "and" ->
        dynamic([p], ^lopd and ^ropd)

      "or" ->
        dynamic([p], ^lopd or ^ropd)
    end
  end

  def handle_filter() do
  end

  def dynamic_func(acc, params) do
    # array_params =
    #   Enum.reduce(params, [], fn x, acc ->
    #     Enum.concat(acc, [x])
    #   end)
    #   |> IO.inspect()
    IO.inspect(params)

    filter_params =
      if params do
        %{"lopd" => lopd, "opr" => opr, "ropd" => ropd} = params

        IO.inspect(lopd, label: "lopd")
        IO.inspect(opr, label: "opr")
        IO.inspect(ropd, label: "ropd")

        case lopd do
          "project_name" ->
            dynamic([p], ^handle_filter(acc, opr, lopd, ropd, :name))

          "start_date" ->
            dynamic([p], ^handle_filter(acc, opr, lopd, ropd, :start_date))

          "end_date" ->
            dynamic([p], ^handle_filter(acc, opr, lopd, ropd, :end_date))

          _ ->
            handle_expression(lopd, opr, ropd)
        end
      else
        true
      end

    filter_params

    # if params["project_name"] && !params["start_date"] && !params["end_date"] do
    #     dynamic(
    #       [project],
    #       project.name == ^params["project_name"]
    #     )
    #   else
    #     dynamic(
    #       [project],
    #       project.name == ^params["project_name"] and
    #         project.start_date >= ^params["start_date"] and
    #         project.end_date <= ^params["end_date"]
    #     )
    #   end
  end

  # fn handle_filter(%{lopd, opr, ropd}) do
  #   case opr do
  #     "and" | "or" => handle_exp(lopd, opr, ropd)
  #     _ => handle_cond(lopd, opr, ropd)
  #   end
  # end

  # fn handle_exp(.., .., ..) do
  #   # handle left + handle right
  #   case opr do
  #     "and" | "or" => handle_filter(lopd, opr, ropd)
  #     _ => handle_cond(lopd, opr, ropd)
  #   end
  # end

  # fn handle_cond(.., .., ..) do
  #   case opr do
  #     "=" | "<" => dynamic()
  #   end
  # end

  def list_user_week_points_dynamic(params) do
    filter_params = dynamic_func(true, params)

    # Project
    # |> join(:inner, [p], p_type in ProjectType, on: p.type_id == p_type.id)
    # |> join(:inner, [p, p_type], pu in ProjectUser, on: pu.project_id == p.id)
    # |> join(:inner, [p, p_type, pu], u in User, on: u.id == pu.user_id)
    # |> join(:inner, [p, p_type, pu, u], uwp in UserWeekPoint,
    #   on: uwp.user_id == u.id and uwp.project_id == p.id
    # )
    # |> select([p, p_type, pu, u, uwp], %{
    #   id: p.id,
    #   name: p.name,
    #   type: p_type.name,
    #   users: [
    #     %{
    #       id: pu.id,
    #       user_id: u.id,
    #       user_name: u.name,
    #       points: [
    #         %{
    #           id: uwp.id,
    #           project_id: uwp.project_id,
    #           user_id: uwp.user_id,
    #           year: uwp.year,
    #           week_of_year: uwp.week_of_year,
    #           month: uwp.month,
    #           plan_point: uwp.plan_point,
    #           actual_point: uwp.actual_point
    #         }
    #       ]
    #     }
    #   ]
    # })
    # |> distinct(true)
    # |> where(
    #   [p, p_type, pu, u, _uwp],
    #   p.name == ^project_name or p.name == "Project B"
    # )
    # |> Repo.all()

    # Project
    # |> where(^filter_params)
    # |> Repo.all()
  end

  def list_personal_week_points_by_week(user_id, year, week) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.user_id == ^user_id and
        user_week_point.year == ^year and user_week_point.week_of_year == ^week
    )
    |> Repo.all()
  end

  def list_user_week_points_by_week_and_paginate(year, week, page, page_size) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.year == ^year and user_week_point.week_of_year == ^week
    )
    |> Repo.all()
    |> Repo.paginate(page: page, page_size: page_size)
  end

  def list_user_week_points_by_user(user_id, year, week) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.user_id == ^user_id and user_week_point.year == ^year and
        user_week_point.week_of_year == ^week
    )
    |> Repo.all()
  end

  def list_my_week_points_in_project(project_id, user_id) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.user_id == ^user_id and user_week_point.project_id == ^project_id
    )
    |> Repo.all()
  end

  @doc """
  Gets a single user_week_point.

  Raises `Ecto.NoResultsError` if the User week point does not exist.

  ## Examples

      iex> get_user_week_point!(123)
      %UserWeekPoint{}

      iex> get_user_week_point!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_week_point!(id), do: Repo.get!(UserWeekPoint, id)

  def get_user_week_point_by_time!(project_id, user_id, year, week) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.project_id == ^project_id and user_week_point.user_id == ^user_id and
        user_week_point.year == ^year and user_week_point.week_of_year == ^week
    )
    |> Repo.one()
  end

  def has_user_week_point_by_time?(project_id, user_id, year, week) do
    UserWeekPoint
    |> where(
      [user_week_point],
      user_week_point.project_id == ^project_id and user_week_point.user_id == ^user_id and
        user_week_point.year == ^year and user_week_point.week_of_year == ^week
    )
    |> Repo.exists?()
  end

  @doc """
  Creates a user_week_point.

  ## Examples

      iex> create_user_week_point(%{field: value})
      {:ok, %UserWeekPoint{}}

      iex> create_user_week_point(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_week_point(attrs \\ %{}) do
    %UserWeekPoint{}
    |> UserWeekPoint.changeset(attrs)
    |> Repo.insert()
  end

  def create_user_week_point_with_metadata(user_id, attrs \\ %{}) do
    %UserWeekPoint{}
    |> UserWeekPoint.changeset(attrs)
    |> Repo.insert_with_metadata(%{user_id: user_id})
  end

  def insert_multiple_week_points(data) do
    UserWeekPoint
    |> Repo.insert_all(data)
  end

  # def update_multiple_week_points(data) do
  #   Repo.update_all(data)
  # end

  @doc """
  Updates a user_week_point.

  ## Examples

      iex> update_user_week_point(user_week_point, %{field: new_value})
      {:ok, %UserWeekPoint{}}

      iex> update_user_week_point(user_week_point, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_week_point(%UserWeekPoint{} = user_week_point, attrs) do
    user_week_point
    |> UserWeekPoint.changeset(attrs)
    |> Repo.update()
  end

  def update_user_week_point_with_metadata(user_id, %UserWeekPoint{} = user_week_point, attrs) do
    user_week_point
    |> UserWeekPoint.changeset(attrs)
    |> Repo.update_with_metadata(%{user_id: user_id})
  end

  @doc """
  Deletes a user_week_point.

  ## Examples

      iex> delete_user_week_point(user_week_point)
      {:ok, %UserWeekPoint{}}

      iex> delete_user_week_point(user_week_point)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_week_point(%UserWeekPoint{} = user_week_point) do
    Repo.delete(user_week_point)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_week_point changes.

  ## Examples

      iex> change_user_week_point(user_week_point)
      %Ecto.Changeset{data: %UserWeekPoint{}}

  """
  def change_user_week_point(%UserWeekPoint{} = user_week_point, attrs \\ %{}) do
    UserWeekPoint.changeset(user_week_point, attrs)
  end
end

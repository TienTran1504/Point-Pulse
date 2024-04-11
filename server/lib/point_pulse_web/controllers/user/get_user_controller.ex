defmodule PointPulseWeb.User.GetUserController do
  use PointPulseWeb, :controller
  alias PointPulse.Users
  alias PointPulse.ProjectUsers
  alias PointPulse.UserPermissions

  action_fallback PointPulseWeb.FallbackController

  @api_param_get_user %{
    user_id: [
      type: :integer,
      required: true
    ]
  }

  @api_param_get_users_paginated %{
    page: [
      type: :integer,
      number: [
        {:greater_than, 0}
      ],
      required: true
    ],
    page_size: [
      type: :integer,
      number: [
        {:greater_than, 0}
      ],
      required: true
    ]
  }

  @api_param_get_users_outside_project %{
    project_id: [
      type: :integer,
      required: true
    ]
  }
  def show(conn, %{"user_id" => id}) do
    user_params = %{user_id: id}

    user_params =
      @api_param_get_user
      |> Validator.parse(user_params)
      |> Validator.get_validated_changes!()

    case Users.get_user!(user_params.user_id) do
      nil ->
        render(conn, :show_message, message: "Can't find user")

      user ->
        permissions = _get_user_permission(user_params.user_id)
        render(conn, :show, %{user: user, permissions: permissions})
    end
  end

  def show_list(conn, _params) do
    users = Users.list_users_exist()
    render(conn, :show_list, users: users)
  end

  def show_list_with_paginated(conn, params) do
    params =
      @api_param_get_users_paginated
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    users = Users.list_users_exist_and_paginate(params.page, params.page_size)
    render(conn, :show_list, users: users)
  end

  defp _get_user_permission(id) do
    user = Users.get_user!(id) |> Users.preload_user_permissions()

    result =
      UserPermissions.preload_permission(user.user_permissions)
      |> Enum.map(fn x -> x.permission_id end)
      |> Enum.sort()

    result
  end

  def show_users_outside_project(conn, %{"project_id" => project_id}) do
    user_params = %{project_id: project_id}

    user_params =
      @api_param_get_users_outside_project
      |> Validator.parse(user_params)
      |> Validator.get_validated_changes!()

    project_users = ProjectUsers.list_users_in_project(user_params.project_id)

    users = Users.list_users_exist()

    new_users =
      Enum.filter(users, fn user ->
        not Enum.any?(project_users, fn project_user -> user.id == project_user.user_id end)
      end)

    render(conn, :show_list, users: new_users)
  end
end

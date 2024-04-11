defmodule PointPulseWeb.UserRole.GetUserRoleController do
  use PointPulseWeb, :controller
  alias PointPulse.UserRoles

  action_fallback PointPulseWeb.FallbackController

  @api_param_get_user_role %{
    user_role_id: [
      type: :integer,
      required: true
    ]
  }

  @api_param_get_user_roles_paginated %{
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

  def show(conn, %{"user_role_id" => id}) do
    user_role_params = %{user_role_id: id}

    user_role_params =
      @api_param_get_user_role
      |> Validator.parse(user_role_params)
      |> Validator.get_validated_changes!()

    case UserRoles.get_user_role!(user_role_params.user_role_id) do
      nil ->
        render(conn, :show_message, message: "Can't find user_role")

      user_role ->
        render(conn, :show, user_role: user_role)
    end
  end

  def show_list(conn, _params) do
    user_roles = UserRoles.list_user_roles_exist()
    render(conn, :show_list, user_roles: user_roles)
  end

  def show_user_roles_paginated(conn, params) do
    params =
      @api_param_get_user_roles_paginated
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    user_roles = UserRoles.list_user_roles_exist_and_paginate(params.page, params.page_size)
    render(conn, :show_list, user_roles: user_roles)
  end
end

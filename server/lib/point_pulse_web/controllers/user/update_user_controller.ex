defmodule PointPulseWeb.User.UpdateUserController do
  use PointPulseWeb, :controller
  alias PointPulseWeb.Exception.ErrorHandler
  alias PointPulseWeb.{Exception.ErrorHandler}
  alias PointPulseWeb.Permission.UpdateUserPermissionsController

  alias PointPulse.Users
  alias PointPulse.Users.User

  action_fallback PointPulseWeb.FallbackController

  @api_param_update_user %{
    user_id: [
      type: :integer,
      required: true
    ],
    weight: [
      type: :float,
      number: [
        {:less_than_or_equal_to, 1},
        {:greater_than, 0}
      ]
    ],
    permissions: [
      type: {:array, :integer},
      items: [
        inclusion: 1..6
      ]
    ]
  }

  def update(conn, user_params) do
    user_params =
      @api_param_update_user
      |> Validator.parse(user_params)
      |> Validator.get_validated_changes!()

    update_user_params = Map.take(user_params, [:user_id, :weight])

    user = Users.get_user!(update_user_params.user_id)

    with {:ok, %User{} = user} <-
           Users.update_user_with_metadata(conn.assigns.user.id, user, update_user_params) do
      permissions =
        UpdateUserPermissionsController.update_permission(
          conn.assigns.user.id,
          user.id,
          user_params.permissions
        )

      render(conn, :show_updated_user, %{user: user, permissions: permissions})
    else
      _ ->
        raise ErrorHandler.BadRequest
    end
  end
end

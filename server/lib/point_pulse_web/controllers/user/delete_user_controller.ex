defmodule PointPulseWeb.User.DeleteUserController do
  use PointPulseWeb, :controller
  alias PointPulse.Users
  alias PointPulse.Users.User

  action_fallback PointPulseWeb.FallbackController

  @api_param_delete_user %{
    user_id: [
      type: :integer,
      required: true
    ]
  }

  def delete(conn, user_params) do
    deleted_at = DateTime.utc_now()

    user_params =
      @api_param_delete_user
      |> Validator.parse(user_params)
      |> Validator.get_validated_changes!()

    user_params =
      user_params
      |> Map.put(:deleted_at, deleted_at)

    user = Users.get_user!(user_params.user_id)

    with {:ok, %User{} = user} <-
           Users.update_user_with_metadata(conn.assigns.user.id, user, user_params) do
      render(conn, :show, user: user)
    end
  end
end

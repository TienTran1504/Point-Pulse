defmodule PointPulseWeb.Auth.LoginController do
  use PointPulseWeb, :controller
  alias PointPulseWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias PointPulse.Users
  alias PointPulse.UserPermissions

  @api_param_types_sign_in %{
    email: [
      type: :string,
      format: ~r/^[^\s]+@[^\s]+$/,
      required: true
    ],
    password: [
      type: :string,
      required: true
    ]
  }

  def sign_in(conn, params) do
    %{email: email, password: password} =
      @api_param_types_sign_in
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    case Guardian.authenticate(email, password) do
      {:ok, user, token} ->
        permissions = _get_user_permissions_id(user.id)

        conn
        |> Plug.Conn.put_session(:user_id, user.id)
        |> put_status(:ok)
        |> render(:show, %{user: user, token: token, permissions: permissions})

      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized, message: "Email or Password incorrect."
    end
  end

  defp _get_user_permissions_id(user_id) do
    user = Users.get_user!(user_id) |> Users.preload_user_permissions()

    result =
      UserPermissions.preload_permission(user.user_permissions)
      |> Enum.map(fn x -> x.permission_id end)
      |> Enum.sort()

    result
  end
end

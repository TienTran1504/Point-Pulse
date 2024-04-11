defmodule PointPulseWeb.User.CreateUserController do
  use PointPulseWeb, :controller
  alias PointPulse.Users
  alias PointPulse.Users.User
  alias PointPulseWeb.Permission.CreateUserPermissionsController

  action_fallback PointPulseWeb.FallbackController

  @api_param_create_user %{
    email: [
      type: :string,
      format: ~r/^[^\s]+@[^\s]+$/,
      required: true
    ],
    password: [
      type: :string,
      required: true
    ],
    name: [
      type: :string,
      required: true
    ],
    weight: [
      type: :float,
      number: [
        {:less_than_or_equal_to, 1},
        {:greater_than, 0}
      ],
      required: true
    ],
    permissions: [
      type: {:array, :integer},
      items: [
        inclusion: 1..6
      ],
      required: true
    ]
  }

  def create(conn, user_params) do
    user_params =
      @api_param_create_user
      |> Validator.parse(user_params)
      |> Validator.get_validated_changes!()

    create_user_params = Map.take(user_params, [:email, :password, :name, :weight])

    with {:ok, %User{} = user} <-
           Users.create_user_with_metadata(conn.assigns.user.id, create_user_params) do
      permissions =
        CreateUserPermissionsController.create_permission(
          conn.assigns.user.id,
          user.id,
          user_params.permissions
        )

      conn
      |> put_status(:created)
      |> render(:show_created_user, %{
        user: user,
        permissions: permissions
      })
    end
  end
end

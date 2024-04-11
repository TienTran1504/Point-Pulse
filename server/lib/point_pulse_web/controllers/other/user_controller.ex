defmodule PointPulseWeb.UserController do
  use PointPulseWeb, :controller
  alias PointPulseWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias PointPulse.{Users, Users.User}

  alias PointPulse.Users
  alias PointPulse.Users.User
  plug :_is_authorized_user when action in [:update, :delete]

  action_fallback PointPulseWeb.FallbackController

  defp _is_authorized_user(conn, _opts) do
    %{params: %{"user" => params}} = conn
    user = Users.get_user!(params["id"])

    if conn.assigns.user.id == user.id do
      conn
    else
      raise ErrorResponse.Forbidden
    end
  end

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    # with {:ok, %User{} = user} <- Users.create_user(user_params)
    #   do
    #   authorize_user(conn, user.email, user_params["password"])
    # end

    with {:ok, %User{} = user} <- Users.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:show, %{user: user, token: token})
    end
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, :show, user: user)
  end

  # def update(conn, %{"user" => user_params}) do
  #   user = Users.get_user!(user_params["id"])

  #   with {:ok, %User{} = user} <-
  #          Users.update_user(user, user_params) do
  #     render(conn, :show, user: user)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    user = Users.get_user!(id)

    with {:ok, %User{}} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end

defmodule PointPulseWeb.Auth.LogoutController do
  use PointPulseWeb, :controller
  alias PointPulseWeb.{Auth.Guardian}

  def sign_out(conn, %{}) do
    user = conn.assigns[:user]
    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)

    conn
    |> Plug.Conn.clear_session()
    |> put_status(:ok)
    |> render(:show, %{user: user, token: nil})
  end
end

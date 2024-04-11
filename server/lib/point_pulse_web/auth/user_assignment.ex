defmodule PointPulseWeb.Auth.UserAssignment do
  import Plug.Conn
  alias PointPulseWeb.Auth.ErrorResponse
  alias PointPulseWeb.Auth.Guardian
  alias PointPulse.Users

  def init(_options) do
  end

  def call(conn, _options) do
    if conn.assigns[:user] do
      conn
    else
      # user_id = get_session(conn, :user_id)
      user_id = Guardian.get_current_user_id(conn)
      if user_id == nil, do: raise(ErrorResponse.Unauthorized)

      user = Users.get_user!(user_id)

      cond do
        user_id && user -> assign(conn, :user, user)
        true -> assign(conn, :user, nil)
      end
    end
  end
end

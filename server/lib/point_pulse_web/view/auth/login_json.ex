defmodule PointPulseWeb.Auth.LoginJSON do
  alias PointPulse.Users.User

  def show(%{user: user, token: token, permissions: permissions}) do
    %{status: :OK, data: data(user, token, permissions)}
  end

  defp data(%User{} = user, token, permissions) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      weight: user.weight,
      token: token,
      permissions: permissions
    }
  end
end

defmodule PointPulseWeb.Auth.LogoutJSON do
  alias PointPulse.Users.User

  @doc """
  Renders a single user.
  """
  def show(%{user: user, token: token}) do
    %{status: :OK, data: data(user, token)}
  end

  defp data(%User{} = user, token) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      weight: user.weight,
      token: token
    }
  end
end

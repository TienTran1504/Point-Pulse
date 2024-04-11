defmodule PointPulseWeb.UserJSON do
  alias PointPulse.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user, token: token}) do
    %{data: data(user, token)}
  end
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      weight: user.weight,
      inserted_by: user.inserted_by,
      updated_by: user.updated_by
    }
  end

  defp data(%User{} = user, token) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      weight: user.weight,
      inserted_by: user.inserted_by,
      updated_by: user.updated_by,
      token: token
    }
  end
end

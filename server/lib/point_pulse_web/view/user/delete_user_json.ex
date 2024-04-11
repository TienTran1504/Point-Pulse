defmodule PointPulseWeb.User.DeleteUserJSON do
  alias PointPulse.Users.User

  def success_message(id) do
    %{status: :OK, message: "Deleted user id: #{id.id} successfully "}
  end

  def show(%{user: user}) do
    %{status: :OK, data: data(user)}
  end

  def show_list(%{users: users}) do
    %{status: :OK, data: for(user <- users, do: data_list(user))}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      weight: user.weight,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at,
      deleted_at: user.deleted_at,
      inserted_by: user.inserted_by,
      updated_by: user.updated_by
    }
  end

  defp data_list(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      password: user.password,
      weight: user.weight,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at,
      deleted_at: user.deleted_at,
      inserted_by: user.inserted_by,
      updated_by: user.updated_by
    }
  end
end

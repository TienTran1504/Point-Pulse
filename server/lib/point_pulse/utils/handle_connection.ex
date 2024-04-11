defmodule PointPulse.Utils.HandleConnection do
  alias PointPulseWeb.Exception.ErrorHandler

  def get_user_id(%{assigns: %{user: %{}}} = _conn) do
    raise ErrorHandler.NotFound
  end

  def get_user_id(%{assigns: %{}} = _conn) do
    raise ErrorHandler.NotFound
  end

  def get_user_id(%{} = _conn) do
    raise ErrorHandler.NotFound
  end

  def get_user_id(%{assigns: %{user: %{id: user_id}}} = _conn) do
    user_id
  end

  def get_user_id(_conn) do
    raise ErrorHandler.NotFound
  end
end

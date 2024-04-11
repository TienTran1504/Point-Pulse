defmodule PointPulseWeb.Auth.Guardian do
  use Guardian, otp_app: :point_pulse
  alias PointPulse.Users

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def get_current_user_id(conn) do
    token = Guardian.Plug.current_token(conn)

    with {:ok, claims} <- decode_and_verify(token) do
      claims["sub"]
    end
  end

  def resource_from_claims(%{"sub" => id}) do
    case Users.get_user!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    case Users.get_user_by_email(email) do
      nil ->
        {:error, :unauthorized}

      user ->
        case _validate_password(password, user.password) do
          true -> _create_token(user, :access)
          # true -> _create_token(user)
          false -> {:error, :unauthorized}
        end
    end
  end

  def authenticate(token) do
    with {:ok, claims} <- decode_and_verify(token),
         {:ok, user} <- resource_from_claims(claims),
         {:ok, _old, {new_token, _claims}} <- refresh(token) do
      {:ok, user, new_token}
    end
  end

  defp _validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  # defp _create_token(user) do
  #   {:ok, token, _claims} = encode_and_sign(user)
  #   {:ok, user, token}
  # end
  defp _create_token(user, type) do
    # {:ok, token, _claims} = encode_and_sign(user, %{}, [ttl: {2, :hour}, token_type: "access"])
    {:ok, token, _claims} = encode_and_sign(user, %{}, _token_options(type))
    {:ok, user, token}
  end

  defp _token_options(type) do
    case type do
      :access ->
        [token_type: "access", ttl: {24, :hour}]
        # :reset -> [token_type: "reset", ttl: {15, :minute}]
        # :admin -> [token_type: "admin", ttl: {90, :day}]
    end
  end

  def after_encode_and_sign(resource, claims, token, _options) do
    with {:ok, _} <- Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token}
    end
  end

  def on_verify(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_refresh({old_token, old_claims}, {new_token, new_claims}, _options) do
    with {:ok, _, _} <- Guardian.DB.on_refresh({old_token, old_claims}, {new_token, new_claims}) do
      {:ok, {old_token, old_claims}, {new_token, new_claims}}
    end
  end

  def on_revoke(claims, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end
end

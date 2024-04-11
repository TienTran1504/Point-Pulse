defmodule PointPulseWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :point_pulse,
    module: PointPulseWeb.Auth.Guardian,
    error_handler: PointPulseWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end

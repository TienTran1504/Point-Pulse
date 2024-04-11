defmodule PointPulseWeb.Auth.ErrorResponse.Unauthorized do
  defexception [message: "Unauthorized", plug_status: 401]
end

defmodule PointPulseWeb.Auth.ErrorResponse.Forbidden do
  defexception [message: "You don't have access to this resource", plug_status: 403]
end

defmodule PointPulseWeb.Auth.ErrorResponse.NotFound do
  defexception [message: "Not Found", plug_status: 404]
end

defmodule PointPulseWeb.Exception.ErrorHandler.BadRequest do
  defexception message: "Bad Request", plug_status: 400
end

defmodule PointPulseWeb.Exception.ErrorHandler.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401
end

defmodule PointPulseWeb.Exception.ErrorHandler.Forbidden do
  defexception message: "You don't have access to this resource", plug_status: 403
end

defmodule PointPulseWeb.Exception.ErrorHandler.NotFound do
  defexception message: "Not Found", plug_status: 404
end

defmodule PointPulseWeb.ErrorJSON do
  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  alias PointPulse.Error

  def error_view(%{error: %Error{} = error}), do: %{errors: [error]}

  def error_view(%{error: error}), do: %{errors: error}

  def internal_server_error(_assigns) do
    %{errors: [%Error{code: Error.c_INTERNAL_SERVER_ERROR()}]}
  end

  def template_not_found(_template, _assigns) do
    %{errors: [%Error{code: Error.c_TEMPLATE_NOT_FOUND()}]}
  end

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end

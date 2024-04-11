defmodule PointPulse.ValidationError do
  @derive {Jason.Encoder, only: [:code, :reason]}
  defexception [:code, :reason]

  @type t :: %__MODULE__{code: String.t(), reason: String.t()}

  @impl true
  def message(%{code: code, reason: reason}) do
    """
    validation failed
      code: #{inspect(code)}
      reason: #{inspect(reason)}
    """
  end

  @impl true
  def exception(opts) do
    code = Keyword.fetch!(opts, :code)
    reason = Keyword.fetch!(opts, :reason)
    %__MODULE__{code: code, reason: reason}
  end
end

defmodule PointPulse.RepoError.BadRequest do
  defexception message: "Bad Request", plug_status: 400
end

defmodule PointPulse.ApplicationError do
  defexception [:reason]

  @impl true
  def message(%{reason: reason}) do
    """
    application error
      reason: #{inspect(reason)}
    """
  end
end

defmodule PointPulse.ErrorResponse.BadRequest do
  defexception message: "Bad Request", plug_status: 400
end

defmodule PointPulse.ErrorCode do
  # Ecto.Changeset error code
  def c_NOT_FOUND, do: "not_found"
  def c_REQUIRED_FIELD, do: "required"
  def c_NO_RESULT_FOUND, do: "no_results_found"
  def c_IS_INVALID, do: "is_invalid"
  def c_VALIDATE_FORMAT, do: "validate_format"
  def c_UNIQUE_CONSTRAINT, do: "unique_constraint"
  def c_FOREIGN_KEY_WRONG, do: "foreign_key_wrong"
  def c_VALIDATE_ACCEPTANCE, do: "validate_acceptance"
  def c_VALIDATE_SUBSET, do: "validate_subset"
  def c_VALIDATE_EXCLUSION, do: "validate_exclusion"
  def c_VALIDATE_CONFIRMATION, do: "validate_confirmation"
  def c_NO_ASSOC_CONSTRAINT, do: "no_assoc_contraint"
  def c_VALIDATE_LENGTH, do: "validate_length"
  def c_VALIDATE_NUMBER, do: "validate_number"
  def c_AT_LEAST_ITEM, do: "at_least_item"
  def c_AT_LEAST_CHARACTER, do: "at_least_character"
  def c_AT_MOST_CHARACTER, do: "at_most_character"
  def c_AT_MOST_ITEM, do: "at_most_item"
  def c_LESS_THAN_NUMBER, do: "less_than_number"
  def c_GREATE_THAN_NUMBER, do: "greate_than_number"
  def c_LESS_THAN_OR_EQUAL, do: "less_than_or_equal"
  def c_GREATE_THAN_OR_EQUAL, do: "greater_than_or_equal_to"
  def c_EQUAL, do: "equal_to"
  def c_NOT_EQUAL, do: "not_equal_to"

  # application error code
  def c_INTERNAL_SERVER_ERROR, do: "internal_server_error"
  def c_UNKNOWN_ERROR, do: "unknow_error"

  # application exception code
  def c_TEMPLATE_NOT_FOUND, do: "template_not_found"
  def c_ROUTE_NOT_FOUND, do: "route_not_found"
end

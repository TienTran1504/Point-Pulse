defmodule PointPulseWeb.Import.ImportPointsJSON do
  def show(%{}) do
    %{status: :OK, message: "Import Points Successfully"}
  end

  def import_error(%{}) do
    %{status: :error, error_code: 1002, message: "Invalid Import File"}
  end
end

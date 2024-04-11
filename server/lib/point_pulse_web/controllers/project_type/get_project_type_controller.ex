defmodule PointPulseWeb.ProjectType.GetProjectTypeController do
  use PointPulseWeb, :controller
  alias PointPulse.ProjectTypes

  action_fallback PointPulseWeb.FallbackController

  @api_param_get_project_type %{
    project_type_id: [
      type: :integer,
      required: true
    ]
  }
  @api_param_get_project_types_paginated %{
    page: [
      type: :integer,
      number: [
        {:greater_than, 0}
      ],
      required: true
    ],
    page_size: [
      type: :integer,
      number: [
        {:greater_than, 0}
      ],
      required: true
    ]
  }

  def show(conn, %{"project_type_id" => id}) do
    project_type_params = %{project_type_id: id}

    project_type_params =
      @api_param_get_project_type
      |> Validator.parse(project_type_params)
      |> Validator.get_validated_changes!()

    case ProjectTypes.get_project_type!(project_type_params.project_type_id) do
      nil ->
        render(conn, :show_message, message: "Can't find project_type")

      project_type ->
        render(conn, :show, project_type: project_type)
    end
  end

  def show_list(conn, _params) do
    project_types = ProjectTypes.list_project_types_exist()

    render(conn, :show_list, project_types: project_types)
  end

  def show_project_types_paginated(conn, params) do
    params =
      @api_param_get_project_types_paginated
      |> Validator.parse(params)
      |> Validator.get_validated_changes!()

    project_types =
      ProjectTypes.list_project_types_exist_and_paginate(params.page, params.page_size)

    render(conn, :show_list, project_types: project_types)
  end
end

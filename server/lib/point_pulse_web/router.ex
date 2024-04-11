defmodule PointPulseWeb.Router do
  use PointPulseWeb, :router
  use Plug.ErrorHandler
  alias PointPulse.Error
  alias PointPulseWeb.ErrorJSON
  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    with {status, error} when not is_nil(error) <- Error.transform(reason) do
      conn
      |> put_status(status)
      |> put_view(ErrorJSON)
      |> render(:error_view, error: error)
    else
      _ ->
        conn
        |> put_status(:internal_server_error)
        |> put_view(ErrorJSON)
        |> render(:internal_server_error)
    end
  end

  def handle_errors(conn, %{reason: %Phoenix.Router.NoRouteError{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn |> json(%{errors: message}) |> halt()
  end

  def handle_errors(conn, reason) do
    conn
    |> put_status(400)
    |> json(%{errors: reason})
    |> Plug.Conn.halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug PointPulseWeb.Auth.Pipeline
    plug PointPulseWeb.Auth.UserAssignment
  end

  pipeline :user_management do
    plug PointPulseWeb.Permission.PipelineUserManagement
  end

  pipeline :master_data_management do
    plug PointPulseWeb.Permission.PipelineMasterDataManagement
  end

  pipeline :project_management do
    plug PointPulseWeb.Permission.PipelineProjectManagement
  end

  pipeline :project_point_management do
    plug PointPulseWeb.Permission.PipelineProjectPointManagement
  end

  pipeline :point_management do
    plug PointPulseWeb.Permission.PipelinePointManagement
  end

  pipeline :view_report_management do
    plug PointPulseWeb.Permission.PipelineViewReportManagement
  end

  scope "/api", PointPulseWeb do
    pipe_through :api
    post "/users/create_test", UserController, :create
    post "/users/sign_in", Auth.LoginController, :sign_in
    post "/calculate_time", Time.GetWeekOfYearController, :show
    post "/paginated/projects", Project.GetProjectController, :show_list_projects_paginated

    post "/paginated/project_types",
         ProjectType.GetProjectTypeController,
         :show_project_types_paginated

    post "/paginated/project_users",
         ProjectUser.GetProjectUserController,
         :show_users_in_project_paginated

    post "/paginated/users", User.GetUserController, :show_list_with_paginated
    post "/paginated/user_roles", UserRole.GetUserRoleController, :show_user_roles_paginated

    post "/paginated/week_points",
         UserWeekPoint.GetUserWeekPointController,
         :show_list_by_week_paginated

    post "/paginated/work_points",
         UserWorkPoint.GetUserWorkPointController,
         :show_list_by_week_paginated
  end

  scope "/api", PointPulseWeb do
    pipe_through [:api, :auth]
    get "/users/by_id/:id", UserController, :show
    post "/users/create", UserController, :create
    post "/users/sign_out", Auth.LogoutController, :sign_out
    post "/users/update", UserController, :update
  end

  # User permissions
  scope "/api/user_permissions", PointPulseWeb do
    pipe_through [:api, :auth]
    get "/", Permission.GetUserPermissionsController, :show
    get "/:id", Permission.GetUserPermissionsController, :get_user_permission
    post "/create", Permission.CreateUserPermissionsController, :create
  end

  # User Management
  scope "/api/user_management", PointPulseWeb do
    pipe_through [:api, :auth, :user_management]
    # CRUD User
    post "/create", User.CreateUserController, :create
    get "/get_all", User.GetUserController, :show_list
    post "/get_all_paginated", User.GetUserController, :show_list_with_paginated
    get "/user/:user_id", User.GetUserController, :show
    delete "/delete", User.DeleteUserController, :delete
    patch "/update", User.UpdateUserController, :update

    # CRUD User Work Point
    post "/insert_user_work_point",
         UserWorkPoint.CreateUserWorkPointController,
         :insert_work_point

    post "/get_all_user_work_points_by_week",
         UserWorkPoint.GetUserWorkPointController,
         :show_list_by_week

    post "/get_user_work_point_by_week",
         UserWorkPoint.GetUserWorkPointController,
         :show_user_work_point_by_week

    patch "/update_user_work_point", UserWorkPoint.UpdateUserWorkPointController, :update
  end

  # Master Data Management
  scope "/api/master_data_management", PointPulseWeb do
    pipe_through [:api, :auth, :master_data_management]
    # User_Role
    post "/create_role", UserRole.CreateUserRoleController, :create
    get "/get_all_roles", UserRole.GetUserRoleController, :show_list
    get "/user_role/:user_role_id", UserRole.GetUserRoleController, :show
    delete "/delete_role", UserRole.DeleteUserRoleController, :delete
    patch "/update_role", UserRole.UpdateUserRoleController, :update

    # Project_Type
    post "/create_project_type", ProjectType.CreateProjectTypeController, :create
    get "/get_all_project_types", ProjectType.GetProjectTypeController, :show_list
    get "/project_type/:project_type_id", ProjectType.GetProjectTypeController, :show
    delete "/delete_project_type", ProjectType.DeleteProjectTypeController, :delete
    patch "/update_project_type", ProjectType.UpdateProjectTypeController, :update
  end

  # Project Management
  scope "/api/project_management", PointPulseWeb do
    # CRUD Project
    pipe_through [:api, :auth, :project_management]
    post "/create", Project.CreateProjectController, :create
    get "/get_all", Project.GetProjectController, :show_list
    get "/:id", Project.GetProjectController, :show
    delete "/delete", Project.DeleteProjectController, :delete
    patch "/update", Project.UpdateProjectController, :update

    # Get project types and user roles
    get "/role/get_all_roles", UserRole.GetUserRoleController, :show_list
    get "/type/get_all_project_types", ProjectType.GetProjectTypeController, :show_list

    # Get Users in Project
    get "/users/:project_id", ProjectUser.GetProjectUserController, :show_users_in_project

    # Get Users outside Project
    get "/users_outside/:project_id", User.GetUserController, :show_users_outside_project

    # Get Project User info
    post "/project_user/get_info", ProjectUser.GetProjectUserController, :show_user_in_project

    # CRUD Project Users
    post "project_users/create", ProjectUser.CreateProjectUserController, :create

    get "project_users/get_users_in_project/:project_id",
        ProjectUser.GetProjectUserController,
        :show_users_in_project

    delete "project_users/delete", ProjectUser.DeleteProjectUserController, :delete
    patch "project_users/update", ProjectUser.UpdateProjectUserController, :update
  end

  # Project Point Management
  scope "/api/project_point_management", PointPulseWeb do
    pipe_through [:api, :auth, :project_point_management]
    # CRUD User Week Point

    post "/insert_actual_point", UserWeekPoint.InsertActualPointController, :insert_actual_point
    post "/insert_plan_point", UserWeekPoint.InsertPlanPointController, :insert_plan_point

    post "/insert_force_actual_point",
         UserWeekPoint.InsertActualPointController,
         :insert_force_actual_point

    post "/insert_force_plan_point",
         UserWeekPoint.InsertPlanPointController,
         :insert_force_plan_point

    post "/insert_multiple_week_point",
         UserWeekPoint.CreateUserWeekPointController,
         :insert_multiple_week_point

    post "/import_points", Import.ImportPoints, :import_points
    post "/upload_file", Import.ImportPoints, :upload_file
    get "/get_projects_unblocked", Project.GetProjectController, :show_list_unblocked
    post "/filter", Filter.FilterPointsController, :filter_data

    post "/get_all_user_week_points_by_week",
         UserWeekPoint.GetUserWeekPointController,
         :show_list_by_week

    ######
    post "/get_week_point", UserWeekPoint.GetUserWeekPointController, :show_week_point
    get "project_users/get_all", ProjectUser.GetProjectUserController, :show_list
  end

  # Point Management
  scope "/api/point_management", PointPulseWeb do
    pipe_through [:api, :auth, :point_management]
    get "/get_projects_unblocked", Project.GetProjectController, :show_list_unblocked
    post "/insert_actual_point", UserWeekPoint.InsertActualPointController, :insert_actual_point
    post "/insert_plan_point", UserWeekPoint.InsertPlanPointController, :insert_plan_point

    post "/insert_force_actual_point",
         UserWeekPoint.InsertActualPointController,
         :insert_force_actual_point

    post "/insert_force_plan_point",
         UserWeekPoint.InsertPlanPointController,
         :insert_force_plan_point

    get "project_users/get_personal",
        ProjectUser.GetProjectUserController,
        :show_personal_projects

    get "project_users/get_managing_projects",
        ProjectUser.GetProjectUserController,
        :show_managing_projects

    get "/project_users/get_in_project/:project_id",
        ProjectUser.GetProjectUserController,
        :show_users_in_project

    post "/insert_multiple_week_point",
         UserWeekPoint.CreateUserWeekPointController,
         :insert_multiple_week_point

    post "/get_personal_week_points_by_week",
         UserWeekPoint.GetUserWeekPointController,
         :show_personal_list_by_week

    post "/get_all_user_week_points_by_week",
         UserWeekPoint.GetUserWeekPointController,
         :show_list_by_week
  end

  # View Report
  scope "/api/view_report_management", PointPulseWeb do
    pipe_through [:api, :auth, :view_report_management]

    get "/get_all_projects", Project.GetProjectController, :show_list
    get "/get_all_users", User.GetUserController, :show_list

    post "/statistic_project_points",
         Statistic.GetStatisticProjectPointsController,
         :show_project_points_in_month

    get "/statistic_all_projects_points",
        Statistic.GetStatisticProjectPointsController,
        :show_projects_points

    post "/statistic_all_projects_points_by_time",
         Statistic.GetStatisticProjectPointsController,
         :show_projects_points_by_time

    post "/statistic_points_by_role",
         Statistic.GetStatisticPointsByRoleController,
         :show_projects_role_points

    post "/statistic_users_percentage_point",
         Statistic.GetStatisticPointPercentageController,
         :show_list_point_percentage

    post "/statistic_work_points",
         Statistic.GetStatisticWorkPointsController,
         :statistic_work_points
  end
end

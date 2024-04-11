defmodule PointPulse.Utils.PermissionConstant do
  @permission_user "user management"
  @permission_master_data "master data management"
  @permission_project "project management"
  @permission_project_point "project point management"
  @permission_point "point management"
  @permission_report "view report management"

  def permission_user, do: @permission_user
  def permission_master_data, do: @permission_master_data
  def permission_project, do: @permission_project
  def permission_project_point, do: @permission_project_point
  def permission_point, do: @permission_point
  def permission_report, do: @permission_report
end

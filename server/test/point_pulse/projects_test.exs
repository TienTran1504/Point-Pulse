defmodule PointPulse.ProjectsTest do
  use PointPulse.DataCase

  alias PointPulse.Projects

  describe "projects" do
    alias PointPulse.Projects.Project

    import PointPulse.ProjectsFixtures

    @invalid_attrs %{name: nil, type_id: nil, plan_point: nil, locked: nil, inserted_by: nil, updated_by: nil}

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Projects.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Projects.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      valid_attrs = %{name: "some name", type_id: 42, plan_point: 120.5, locked: true, inserted_by: 42, updated_by: 42}

      assert {:ok, %Project{} = project} = Projects.create_project(valid_attrs)
      assert project.name == "some name"
      assert project.type_id == 42
      assert project.plan_point == 120.5
      assert project.locked == true
      assert project.inserted_by == 42
      assert project.updated_by == 42
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      update_attrs = %{name: "some updated name", type_id: 43, plan_point: 456.7, locked: false, inserted_by: 43, updated_by: 43}

      assert {:ok, %Project{} = project} = Projects.update_project(project, update_attrs)
      assert project.name == "some updated name"
      assert project.type_id == 43
      assert project.plan_point == 456.7
      assert project.locked == false
      assert project.inserted_by == 43
      assert project.updated_by == 43
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_project(project, @invalid_attrs)
      assert project == Projects.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Projects.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Projects.change_project(project)
    end
  end
end

defmodule PointPulse.ProjectTypesTest do
  use PointPulse.DataCase

  alias PointPulse.ProjectTypes

  describe "project_types" do
    alias PointPulse.ProjectTypes.ProjectType

    import PointPulse.ProjectTypesFixtures

    @invalid_attrs %{name: nil, inserted_by: nil, updated_by: nil}

    test "list_project_types/0 returns all project_types" do
      project_type = project_type_fixture()
      assert ProjectTypes.list_project_types() == [project_type]
    end

    test "get_project_type!/1 returns the project_type with given id" do
      project_type = project_type_fixture()
      assert ProjectTypes.get_project_type!(project_type.id) == project_type
    end

    test "create_project_type/1 with valid data creates a project_type" do
      valid_attrs = %{name: "some name", inserted_by: "some inserted_by", updated_by: "some updated_by"}

      assert {:ok, %ProjectType{} = project_type} = ProjectTypes.create_project_type(valid_attrs)
      assert project_type.name == "some name"
      assert project_type.inserted_by == "some inserted_by"
      assert project_type.updated_by == "some updated_by"
    end

    test "create_project_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProjectTypes.create_project_type(@invalid_attrs)
    end

    test "update_project_type/2 with valid data updates the project_type" do
      project_type = project_type_fixture()
      update_attrs = %{name: "some updated name", inserted_by: "some updated inserted_by", updated_by: "some updated updated_by"}

      assert {:ok, %ProjectType{} = project_type} = ProjectTypes.update_project_type(project_type, update_attrs)
      assert project_type.name == "some updated name"
      assert project_type.inserted_by == "some updated inserted_by"
      assert project_type.updated_by == "some updated updated_by"
    end

    test "update_project_type/2 with invalid data returns error changeset" do
      project_type = project_type_fixture()
      assert {:error, %Ecto.Changeset{}} = ProjectTypes.update_project_type(project_type, @invalid_attrs)
      assert project_type == ProjectTypes.get_project_type!(project_type.id)
    end

    test "delete_project_type/1 deletes the project_type" do
      project_type = project_type_fixture()
      assert {:ok, %ProjectType{}} = ProjectTypes.delete_project_type(project_type)
      assert_raise Ecto.NoResultsError, fn -> ProjectTypes.get_project_type!(project_type.id) end
    end

    test "change_project_type/1 returns a project_type changeset" do
      project_type = project_type_fixture()
      assert %Ecto.Changeset{} = ProjectTypes.change_project_type(project_type)
    end
  end
end

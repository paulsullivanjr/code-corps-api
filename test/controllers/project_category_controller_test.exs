defmodule CodeCorps.ProjectCategoryControllerTest do
  use CodeCorps.ApiCase, resource_name: :project_category

  describe "index" do
    test "lists all entries on index", %{conn: conn} do
      [project_category_1, project_category_2] = insert_pair(:project_category)

      conn
      |> request_index
      |> json_response(200)
      |> assert_ids_from_response([project_category_1.id, project_category_2.id])
    end

    test "filters resources on index", %{conn: conn} do
      [project_category_1, project_category_2 | _] = insert_list(3, :project_category)

      path = "project-categories/?filter[id]=#{project_category_1.id},#{project_category_2.id}"

      conn
      |> get(path)
      |> json_response(200)
      |> assert_ids_from_response([project_category_1.id, project_category_2.id])
    end
  end

  describe "show" do
    test "shows chosen resource", %{conn: conn} do
      category = insert(:category)
      project = insert(:project)
      project_category = insert(:project_category, project: project, category: category)

      conn
      |> request_show(project_category)
      |> json_response(200)
      |> Map.get("data")
      |> assert_result_id(project_category.id)
    end

    test "renders 404 when id is nonexistent", %{conn: conn} do
      assert conn |> request_show(:not_found) |> json_response(404)
    end
  end

  describe "create" do
    @tag authenticated: :admin
    test "creates and renders resource when data is valid", %{conn: conn} do
      organization = insert(:organization)
      category = insert(:category)
      project = insert(:project, organization: organization)

      attrs = %{category: category, project: project}
      assert conn |> request_create(attrs) |> json_response(201)
    end

    @tag authenticated: :admin
    test "renders 422 when data is invalid", %{conn: conn} do
      invalid_attrs = %{}
      assert conn |> request_create(invalid_attrs) |> json_response(422)
    end

    test "renders 401 when unauthenticated", %{conn: conn} do
      assert conn |> request_create |> json_response(401)
    end

    @tag :authenticated
    test "renders 403 when not authorized", %{conn: conn} do
      assert conn |> request_create |> json_response(403)
    end
  end

  describe "delete" do
    @tag authenticated: :admin
    test "deletes resource", %{conn: conn} do
      assert conn |> request_delete |> response(204)
    end

    test "renders 401 when unauthenticated", %{conn: conn} do
      assert conn |> request_delete |> json_response(401)
    end

    @tag :authenticated
    test "renders 403 when not authorized", %{conn: conn} do
      assert conn |> request_delete |> json_response(403)
    end

    @tag :authenticated
    test "renders 404 when id is nonexistent", %{conn: conn} do
      assert conn |> request_delete(:not_found) |> json_response(404)
    end
  end
end

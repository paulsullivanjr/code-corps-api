defmodule CodeCorps.CategoryControllerTest do
  use CodeCorps.ApiCase, resource_name: :category

  alias CodeCorps.Category

  @valid_attrs %{description: "You want to improve software tools and infrastructure.", name: "Technology"}
  @invalid_attrs %{name: nil}

  def request_create(conn, attrs) do
    path = conn |> category_path(:create)
    payload = json_payload(:category, attrs)
    conn |> post(path, payload)
  end

  def request_update(conn, attrs) do
    category = insert(:category)
    payload = json_payload(:category, attrs)
    path = conn |> category_path(:update, category)

    conn |> put(path, payload)
  end

  test "lists all entries on index", %{conn: conn} do
    [category_1, category_2] = insert_pair(:category)

    conn
    |> request_index
    |> json_response(200)
    |> assert_ids_from_response([category_1.id, category_2.id])
  end

  describe "show" do
    test "shows chosen resource", %{conn: conn} do
      category = insert(:category)

      conn
      |> request_show(category)
      |> json_response(200)
      |> Map.get("data")
      |> assert_result_id(category.id)
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert conn |> request_show(:not_found) |> json_response(404)
    end
  end

  describe "create" do
    @tag authenticated: :admin
    test "creates and renders resource when data is valid", %{conn: conn} do
      assert conn |> request_create(@valid_attrs) |> json_response(201)
    end

    @tag authenticated: :admin
    test "renders 404 when data is invalid", %{conn: conn} do
      response = conn |> request_create(@invalid_attrs) |> json_response(422)
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      assert conn |> request_create |> json_response(401)
    end

    @tag :authenticated
    test "renders 403 when not authorized", %{conn: conn} do
      assert conn |> request_create |> json_response(403)
    end
  end

  describe "update" do
    @tag authenticated: :admin
    test "updates and renders chosen resource when data is valid", %{conn: conn} do
      response = conn |> request_update(@valid_attrs) |> json_response(200)
    end

    @tag authenticated: :admin
    test "renders 404 when data is invalid", %{conn: conn} do
      response = conn |> request_update(@invalid_attrs) |> json_response(422)
    end

    test "renders 401 when not authenticated", %{conn: conn} do
      assert conn |> request_update |> json_response(401)
    end

    @tag :authenticated
    test "renders 403 when not authorized", %{conn: conn} do
      assert conn |> request_update |> json_response(403)
    end
  end
end

defmodule TypesenseEx.CollectionsTest do
  use ExUnit.Case

  alias TypesenseEx.Collections

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    collection_name = "test_collections_#{System.unique_integer([:positive])}"

    schema = %{
      name: collection_name,
      fields: [
        %{name: "title", type: "string"},
        %{name: "score", type: "int32"}
      ],
      default_sorting_field: "score"
    }

    on_exit(fn ->
      Collections.delete(client, collection_name)
    end)

    %{client: client, collection_name: collection_name, schema: schema}
  end

  describe "create/2" do
    test "creates a collection", %{client: client, schema: schema} do
      assert {:ok, collection} = Collections.create(client, schema)
      assert collection["name"] == schema.name
      assert length(collection["fields"]) >= 2
    end

    test "returns error for duplicate collection", %{client: client, schema: schema} do
      {:ok, _} = Collections.create(client, schema)
      assert {:error, %{"message" => _}} = Collections.create(client, schema)
    end
  end

  describe "list/1" do
    test "lists collections", %{client: client, schema: schema} do
      {:ok, _} = Collections.create(client, schema)
      assert {:ok, collections} = Collections.list(client)
      assert is_list(collections)
      assert Enum.any?(collections, &(&1["name"] == schema.name))
    end
  end

  describe "get/2" do
    test "retrieves a collection", %{client: client, collection_name: name, schema: schema} do
      {:ok, _} = Collections.create(client, schema)
      assert {:ok, collection} = Collections.get(client, name)
      assert collection["name"] == name
    end

    test "returns error for non-existent collection", %{client: client} do
      assert {:error, %{"message" => _}} = Collections.get(client, "nonexistent_xyz")
    end
  end

  describe "update/3" do
    test "updates a collection's fields", %{client: client, collection_name: name, schema: schema} do
      {:ok, _} = Collections.create(client, schema)

      update = %{
        fields: [%{name: "description", type: "string"}]
      }

      assert {:ok, result} = Collections.update(client, name, update)
      assert is_map(result)
    end
  end

  describe "delete/2" do
    test "deletes a collection", %{client: client, collection_name: name, schema: schema} do
      {:ok, _} = Collections.create(client, schema)
      assert {:ok, deleted} = Collections.delete(client, name)
      assert deleted["name"] == name
      assert {:error, _} = Collections.get(client, name)
    end
  end
end

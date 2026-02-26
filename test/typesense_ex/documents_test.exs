defmodule TypesenseEx.DocumentsTest do
  use ExUnit.Case

  alias TypesenseEx.{Collections, Documents}

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    collection_name = "test_docs_#{System.unique_integer([:positive])}"

    schema = %{
      name: collection_name,
      fields: [
        %{name: "title", type: "string"},
        %{name: "score", type: "int32"}
      ],
      default_sorting_field: "score"
    }

    {:ok, _} = Collections.create(client, schema)

    on_exit(fn ->
      Collections.delete(client, collection_name)
    end)

    %{client: client, collection: collection_name}
  end

  describe "index/3" do
    test "indexes a document", %{client: client, collection: coll} do
      doc = %{title: "Test Doc", score: 10}
      assert {:ok, result} = Documents.index(client, coll, doc)
      assert result["title"] == "Test Doc"
      assert result["id"]
    end
  end

  describe "get/3" do
    test "retrieves a document by id", %{client: client, collection: coll} do
      {:ok, indexed} = Documents.index(client, coll, %{title: "Get Test", score: 5})
      assert {:ok, doc} = Documents.get(client, coll, indexed["id"])
      assert doc["title"] == "Get Test"
    end

    test "returns error for non-existent document", %{client: client, collection: coll} do
      assert {:error, _} = Documents.get(client, coll, "nonexistent_999")
    end
  end

  describe "update/4" do
    test "updates a document", %{client: client, collection: coll} do
      {:ok, indexed} = Documents.index(client, coll, %{title: "Original", score: 1})
      assert {:ok, updated} = Documents.update(client, coll, indexed["id"], %{title: "Updated"})
      assert updated["title"] == "Updated"
    end
  end

  describe "delete/3" do
    test "deletes a document by id", %{client: client, collection: coll} do
      {:ok, indexed} = Documents.index(client, coll, %{title: "To Delete", score: 1})
      assert {:ok, deleted} = Documents.delete(client, coll, indexed["id"])
      assert deleted["id"] == indexed["id"]
      assert {:error, _} = Documents.get(client, coll, indexed["id"])
    end
  end

  describe "import/3" do
    test "imports documents in bulk", %{client: client, collection: coll} do
      docs = [
        %{title: "Bulk 1", score: 10},
        %{title: "Bulk 2", score: 20}
      ]

      assert {:ok, results} = Documents.import(client, coll, docs)
      assert length(results) == 2
      assert Enum.all?(results, &(&1["success"] == true))
    end
  end

  describe "export/2" do
    test "exports documents as JSONL", %{client: client, collection: coll} do
      Documents.index(client, coll, %{title: "Export 1", score: 1})
      Documents.index(client, coll, %{title: "Export 2", score: 2})

      assert {:ok, docs} = Documents.export(client, coll)
      assert length(docs) == 2
    end
  end

  describe "update_by_filter/3" do
    test "updates documents matching filter", %{client: client, collection: coll} do
      Documents.index(client, coll, %{title: "Filter Update", score: 100})

      assert {:ok, %{"num_updated" => 1}} =
               Documents.update_by_filter(client, coll, %{title: "Filtered"}, "score:>50")
    end
  end

  describe "delete_by_filter/3" do
    test "deletes documents matching filter", %{client: client, collection: coll} do
      Documents.index(client, coll, %{title: "Filter Delete", score: 200})

      assert {:ok, %{"num_deleted" => 1}} =
               Documents.delete_by_filter(client, coll, "score:>150")
    end
  end
end

defmodule TypesenseEx.SearchTest do
  use ExUnit.Case

  alias TypesenseEx.{Collections, Documents, Search}

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    collection_name = "test_search_#{System.unique_integer([:positive])}"

    schema = %{
      name: collection_name,
      fields: [
        %{name: "title", type: "string"},
        %{name: "category", type: "string", facet: true},
        %{name: "score", type: "int32"}
      ],
      default_sorting_field: "score"
    }

    {:ok, _} = Collections.create(client, schema)

    docs = [
      %{title: "Alpha Widget", category: "widgets", score: 10},
      %{title: "Beta Widget", category: "widgets", score: 20},
      %{title: "Gamma Gadget", category: "gadgets", score: 30}
    ]

    Documents.import(client, collection_name, docs)

    on_exit(fn ->
      Collections.delete(client, collection_name)
    end)

    %{client: client, collection: collection_name}
  end

  describe "search/3" do
    test "searches documents by query", %{client: client, collection: coll} do
      assert {:ok, result} = Search.search(client, coll, %{q: "Widget", query_by: "title"})
      assert result["found"] == 2
      assert length(result["hits"]) == 2
    end

    test "searches with wildcard query", %{client: client, collection: coll} do
      assert {:ok, result} = Search.search(client, coll, %{q: "*", query_by: "title"})
      assert result["found"] == 3
    end

    test "searches with filter", %{client: client, collection: coll} do
      assert {:ok, result} =
               Search.search(client, coll, %{
                 q: "*",
                 query_by: "title",
                 filter_by: "category:widgets"
               })

      assert result["found"] == 2
    end

    test "returns facet counts", %{client: client, collection: coll} do
      assert {:ok, result} =
               Search.search(client, coll, %{
                 q: "*",
                 query_by: "title",
                 facet_by: "category"
               })

      assert length(result["facet_counts"]) > 0
    end
  end

  describe "multi_search/3" do
    test "performs multiple searches", %{client: client, collection: coll} do
      searches = %{
        searches: [
          %{collection: coll, q: "Widget", query_by: "title"},
          %{collection: coll, q: "Gadget", query_by: "title"}
        ]
      }

      assert {:ok, result} = Search.multi_search(client, searches)
      assert length(result["results"]) == 2
      assert Enum.at(result["results"], 0)["found"] == 2
      assert Enum.at(result["results"], 1)["found"] == 1
    end
  end
end

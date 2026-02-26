defmodule TypesenseEx.CurationSetsTest do
  use ExUnit.Case

  alias TypesenseEx.CurationSets

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    set_name = "test_cur_#{System.unique_integer([:positive])}"

    on_exit(fn ->
      CurationSets.delete(client, set_name)
    end)

    %{client: client, set_name: set_name}
  end

  describe "curation set CRUD" do
    test "upserts, gets, lists, and deletes a curation set", %{client: client, set_name: name} do
      body = %{items: []}
      assert {:ok, created} = CurationSets.upsert(client, name, body)
      assert created["name"] == name

      assert {:ok, fetched} = CurationSets.get(client, name)
      assert fetched["name"] == name

      assert {:ok, sets} = CurationSets.list(client)
      assert is_list(sets)

      assert {:ok, _} = CurationSets.delete(client, name)
      assert {:error, _} = CurationSets.get(client, name)
    end
  end

  describe "curation set items" do
    test "upserts, gets, lists, and deletes items", %{client: client, set_name: name} do
      {:ok, _} = CurationSets.upsert(client, name, %{items: []})

      item = %{rule: %{query: "apple", match: "exact"}, includes: [], excludes: []}
      assert {:ok, created} = CurationSets.upsert_item(client, name, "apple_rule", item)
      assert created["id"] == "apple_rule"

      assert {:ok, fetched} = CurationSets.get_item(client, name, "apple_rule")
      assert fetched["id"] == "apple_rule"

      assert {:ok, items} = CurationSets.list_items(client, name)
      assert is_list(items)

      assert {:ok, _} = CurationSets.delete_item(client, name, "apple_rule")
    end
  end
end

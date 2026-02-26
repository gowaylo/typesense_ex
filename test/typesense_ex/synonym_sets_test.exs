defmodule TypesenseEx.SynonymSetsTest do
  use ExUnit.Case

  alias TypesenseEx.SynonymSets

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    set_name = "test_syn_#{System.unique_integer([:positive])}"

    on_exit(fn ->
      SynonymSets.delete(client, set_name)
    end)

    %{client: client, set_name: set_name}
  end

  describe "synonym set CRUD" do
    test "upserts, gets, lists, and deletes a synonym set", %{client: client, set_name: name} do
      body = %{items: []}
      assert {:ok, created} = SynonymSets.upsert(client, name, body)
      assert created["name"] == name

      assert {:ok, fetched} = SynonymSets.get(client, name)
      assert fetched["name"] == name

      assert {:ok, sets} = SynonymSets.list(client)
      assert is_list(sets)

      assert {:ok, _} = SynonymSets.delete(client, name)
      assert {:error, _} = SynonymSets.get(client, name)
    end
  end

  describe "synonym set items" do
    test "upserts, gets, lists, and deletes items", %{client: client, set_name: name} do
      {:ok, _} = SynonymSets.upsert(client, name, %{items: []})

      item = %{synonyms: ["blazer", "coat", "jacket"]}
      assert {:ok, created} = SynonymSets.upsert_item(client, name, "outerwear", item)
      assert created["id"] == "outerwear"

      assert {:ok, fetched} = SynonymSets.get_item(client, name, "outerwear")
      assert fetched["id"] == "outerwear"

      assert {:ok, items} = SynonymSets.list_items(client, name)
      assert is_list(items)

      assert {:ok, _} = SynonymSets.delete_item(client, name, "outerwear")
    end
  end
end

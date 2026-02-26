defmodule TypesenseEx.AliasesTest do
  use ExUnit.Case

  alias TypesenseEx.{Collections, Aliases}

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    collection_name = "test_aliases_coll_#{System.unique_integer([:positive])}"
    alias_name = "test_alias_#{System.unique_integer([:positive])}"

    {:ok, _} =
      Collections.create(client, %{
        name: collection_name,
        fields: [%{name: "title", type: "string"}]
      })

    on_exit(fn ->
      Aliases.delete(client, alias_name)
      Collections.delete(client, collection_name)
    end)

    %{client: client, collection: collection_name, alias_name: alias_name}
  end

  describe "upsert/3" do
    test "creates an alias", %{client: client, collection: coll, alias_name: name} do
      assert {:ok, result} = Aliases.upsert(client, name, %{collection_name: coll})
      assert result["name"] == name
      assert result["collection_name"] == coll
    end
  end

  describe "get/2" do
    test "retrieves an alias", %{client: client, collection: coll, alias_name: name} do
      {:ok, _} = Aliases.upsert(client, name, %{collection_name: coll})
      assert {:ok, result} = Aliases.get(client, name)
      assert result["collection_name"] == coll
    end
  end

  describe "list/1" do
    test "lists all aliases", %{client: client, collection: coll, alias_name: name} do
      {:ok, _} = Aliases.upsert(client, name, %{collection_name: coll})
      assert {:ok, %{"aliases" => aliases}} = Aliases.list(client)
      assert is_list(aliases)
      assert Enum.any?(aliases, &(&1["name"] == name))
    end
  end

  describe "delete/2" do
    test "deletes an alias", %{client: client, collection: coll, alias_name: name} do
      {:ok, _} = Aliases.upsert(client, name, %{collection_name: coll})
      assert {:ok, _} = Aliases.delete(client, name)
      assert {:error, _} = Aliases.get(client, name)
    end
  end
end

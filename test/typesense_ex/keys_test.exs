defmodule TypesenseEx.KeysTest do
  use ExUnit.Case

  alias TypesenseEx.Keys

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    %{client: client}
  end

  describe "create/2 and lifecycle" do
    test "creates, gets, lists, and deletes an API key", %{client: client} do
      key_schema = %{
        description: "Test key",
        actions: ["documents:search"],
        collections: ["*"]
      }

      assert {:ok, created} = Keys.create(client, key_schema)
      assert created["description"] == "Test key"
      assert created["value"]
      key_id = created["id"]

      assert {:ok, fetched} = Keys.get(client, key_id)
      assert fetched["description"] == "Test key"

      assert {:ok, %{"keys" => keys}} = Keys.list(client)
      assert is_list(keys)
      assert Enum.any?(keys, &(&1["id"] == key_id))

      assert {:ok, deleted} = Keys.delete(client, key_id)
      assert deleted["id"] == key_id
    end
  end
end

defmodule TypesenseEx.OperationsTest do
  use ExUnit.Case

  alias TypesenseEx.Operations

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    %{client: client}
  end

  describe "schema_changes/1" do
    test "returns schema changes status", %{client: client} do
      assert {:ok, _result} = Operations.schema_changes(client)
    end
  end

  describe "clear_cache/1" do
    test "clears the search cache", %{client: client} do
      assert {:ok, %{"success" => true}} = Operations.clear_cache(client)
    end
  end

  describe "compact_db/1" do
    test "compacts the database", %{client: client} do
      assert {:ok, %{"success" => true}} = Operations.compact_db(client)
    end
  end

  describe "config/2" do
    test "toggles slow request log", %{client: client} do
      assert {:ok, %{"success" => true}} =
               Operations.config(client, %{"log-slow-requests-time-ms" => -1})
    end
  end
end

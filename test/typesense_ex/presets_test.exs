defmodule TypesenseEx.PresetsTest do
  use ExUnit.Case

  alias TypesenseEx.Presets

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    preset_id = "test_preset_#{System.unique_integer([:positive])}"

    on_exit(fn ->
      Presets.delete(client, preset_id)
    end)

    %{client: client, preset_id: preset_id}
  end

  describe "presets CRUD" do
    test "upserts, gets, lists, and deletes a preset", %{client: client, preset_id: id} do
      body = %{value: %{searches: [%{q: "test", query_by: "title"}]}}
      assert {:ok, created} = Presets.upsert(client, id, body)
      assert is_map(created)

      assert {:ok, fetched} = Presets.get(client, id)
      assert is_map(fetched)

      assert {:ok, result} = Presets.list(client)
      assert is_map(result)

      assert {:ok, _} = Presets.delete(client, id)
    end
  end
end

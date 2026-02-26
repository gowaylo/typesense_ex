defmodule TypesenseEx.StopwordsTest do
  use ExUnit.Case

  alias TypesenseEx.Stopwords

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    set_id = "test_stop_#{System.unique_integer([:positive])}"

    on_exit(fn ->
      Stopwords.delete(client, set_id)
    end)

    %{client: client, set_id: set_id}
  end

  describe "stopwords CRUD" do
    test "upserts, gets, lists, and deletes a stopwords set", %{client: client, set_id: id} do
      body = %{stopwords: ["the", "a", "an"], locale: "en"}
      assert {:ok, created} = Stopwords.upsert(client, id, body)
      assert is_map(created)

      assert {:ok, fetched} = Stopwords.get(client, id)
      assert is_map(fetched)

      assert {:ok, result} = Stopwords.list(client)
      assert is_map(result)

      assert {:ok, _} = Stopwords.delete(client, id)
    end
  end
end

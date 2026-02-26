defmodule TypesenseEx.StemmingTest do
  use ExUnit.Case

  alias TypesenseEx.Stemming

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    %{client: client}
  end

  describe "list_dictionaries/1" do
    test "lists stemming dictionaries", %{client: client} do
      assert {:ok, result} = Stemming.list_dictionaries(client)
      assert is_map(result)
    end
  end

  describe "import and get dictionary" do
    test "imports and retrieves a stemming dictionary", %{client: client} do
      dict_id = "test_dict_#{System.unique_integer([:positive])}"

      words = [
        %{word: "people", root: "person"},
        %{word: "children", root: "child"}
      ]

      assert {:ok, _} = Stemming.import_dictionary(client, dict_id, words)

      assert {:ok, result} = Stemming.get_dictionary(client, dict_id)
      assert is_map(result)
    end
  end
end

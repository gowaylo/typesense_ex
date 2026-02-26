defmodule TypesenseEx.NLSearchModelsTest do
  use ExUnit.Case

  alias TypesenseEx.NLSearchModels

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    %{client: client}
  end

  describe "list/1" do
    test "lists NL search models", %{client: client} do
      assert {:ok, models} = NLSearchModels.list(client)
      assert is_list(models)
    end
  end
end

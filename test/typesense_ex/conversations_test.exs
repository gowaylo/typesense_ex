defmodule TypesenseEx.ConversationsTest do
  use ExUnit.Case

  alias TypesenseEx.Conversations

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    %{client: client}
  end

  describe "list_models/1" do
    test "lists conversation models", %{client: client} do
      assert {:ok, models} = Conversations.list_models(client)
      assert is_list(models)
    end
  end
end

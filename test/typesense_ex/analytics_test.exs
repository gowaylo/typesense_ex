defmodule TypesenseEx.AnalyticsTest do
  use ExUnit.Case

  alias TypesenseEx.{Collections, Analytics}

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    rule_name = "test_rule_#{System.unique_integer([:positive])}"
    source_coll = "test_analytics_src_#{System.unique_integer([:positive])}"
    dest_coll = "test_analytics_dest_#{System.unique_integer([:positive])}"

    {:ok, _} =
      Collections.create(client, %{
        name: source_coll,
        fields: [%{name: "title", type: "string"}]
      })

    {:ok, _} =
      Collections.create(client, %{
        name: dest_coll,
        fields: [
          %{name: "q", type: "string"},
          %{name: "count", type: "int32"}
        ],
        default_sorting_field: "count"
      })

    on_exit(fn ->
      Analytics.delete_rule(client, rule_name)
      Collections.delete(client, source_coll)
      Collections.delete(client, dest_coll)
    end)

    %{client: client, rule_name: rule_name, source: source_coll, dest: dest_coll}
  end

  describe "analytics rules" do
    test "creates, gets, lists, and deletes a rule", %{
      client: client,
      rule_name: name,
      source: source,
      dest: dest
    } do
      rule = %{
        name: name,
        type: "popular_queries",
        collection: source,
        event_type: "search",
        params: %{
          destination_collection: dest,
          limit: 100
        }
      }

      assert {:ok, created} = Analytics.create_rule(client, rule)
      assert created["name"] == name

      assert {:ok, fetched} = Analytics.get_rule(client, name)
      assert fetched["name"] == name

      assert {:ok, rules} = Analytics.list_rules(client)
      assert is_list(rules)

      assert {:ok, _} = Analytics.delete_rule(client, name)
    end
  end

  describe "analytics status" do
    test "returns status info", %{client: client} do
      assert {:ok, status} = Analytics.status(client)
      assert is_map(status)
    end
  end

  describe "analytics flush" do
    test "flushes analytics", %{client: client} do
      assert {:ok, _} = Analytics.flush(client)
    end
  end
end

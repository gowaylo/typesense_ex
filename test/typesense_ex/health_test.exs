defmodule TypesenseEx.HealthTest do
  use ExUnit.Case

  setup do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    %{client: client}
  end

  describe "health/1" do
    test "returns ok when server is healthy", %{client: client} do
      assert {:ok, %{"ok" => true}} = TypesenseEx.Health.health(client)
    end
  end

  describe "debug/1" do
    test "returns debug info with version", %{client: client} do
      assert {:ok, %{"version" => _version}} = TypesenseEx.Health.debug(client)
    end
  end

  describe "metrics/1" do
    test "returns server metrics", %{client: client} do
      assert {:ok, metrics} = TypesenseEx.Health.metrics(client)
      assert is_map(metrics)
    end
  end

  describe "stats/1" do
    test "returns API stats", %{client: client} do
      assert {:ok, stats} = TypesenseEx.Health.stats(client)
      assert is_map(stats)
    end
  end
end

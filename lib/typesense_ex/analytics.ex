defmodule TypesenseEx.Analytics do
  def list_rules(client, params \\ []) do
    TypesenseEx.get(client, "/analytics/rules", params)
  end

  def get_rule(client, name) do
    TypesenseEx.get(client, "/analytics/rules/#{name}")
  end

  def create_rule(client, rule) do
    TypesenseEx.post(client, "/analytics/rules", rule)
  end

  def upsert_rule(client, name, rule) do
    TypesenseEx.put(client, "/analytics/rules/#{name}", rule)
  end

  def delete_rule(client, name) do
    TypesenseEx.delete(client, "/analytics/rules/#{name}")
  end

  def create_event(client, event) do
    TypesenseEx.post(client, "/analytics/events", event)
  end

  def get_events(client, params) do
    TypesenseEx.get(client, "/analytics/events", Map.to_list(params))
  end

  def flush(client) do
    TypesenseEx.post(client, "/analytics/flush")
  end

  def status(client) do
    TypesenseEx.get(client, "/analytics/status")
  end
end

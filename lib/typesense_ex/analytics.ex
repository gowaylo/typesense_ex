defmodule TypesenseEx.Analytics do
  @moduledoc """
  Search analytics: rules, events, and status.

  Analytics rules define what data Typesense collects (e.g., popular queries, click events).
  Events represent individual search or click interactions.

  ## Example

      {:ok, rule} = TypesenseEx.Analytics.create_rule(client, %{
        "name" => "popular_queries",
        "type" => "popular_queries",
        "params" => %{"source" => %{"collections" => ["books"]}}
      })
  """

  @doc "Lists analytics rules. Pass optional query params as a keyword list."
  def list_rules(client, params \\ []) do
    TypesenseEx.get(client, "/analytics/rules", params)
  end

  @doc "Retrieves an analytics rule by name."
  def get_rule(client, name) do
    TypesenseEx.get(client, "/analytics/rules/#{name}")
  end

  @doc "Creates a new analytics rule."
  def create_rule(client, rule) do
    TypesenseEx.post(client, "/analytics/rules", rule)
  end

  @doc "Creates or updates an analytics rule by name."
  def upsert_rule(client, name, rule) do
    TypesenseEx.put(client, "/analytics/rules/#{name}", rule)
  end

  @doc "Deletes an analytics rule by name."
  def delete_rule(client, name) do
    TypesenseEx.delete(client, "/analytics/rules/#{name}")
  end

  @doc "Logs an analytics event (e.g., search query, click)."
  def create_event(client, event) do
    TypesenseEx.post(client, "/analytics/events", event)
  end

  @doc "Retrieves analytics events. Pass search params as a map."
  def get_events(client, params) do
    TypesenseEx.get(client, "/analytics/events", Map.to_list(params))
  end

  @doc "Flushes pending analytics data."
  def flush(client) do
    TypesenseEx.post(client, "/analytics/flush")
  end

  @doc "Returns the current analytics status."
  def status(client) do
    TypesenseEx.get(client, "/analytics/status")
  end
end

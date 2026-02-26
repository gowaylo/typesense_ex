defmodule TypesenseEx.Operations do
  def schema_changes(client) do
    TypesenseEx.get(client, "/operations/schema_changes")
  end

  def snapshot(client, snapshot_path) do
    TypesenseEx.post(client, "/operations/snapshot?snapshot_path=#{URI.encode(snapshot_path)}")
  end

  def vote(client) do
    TypesenseEx.post(client, "/operations/vote")
  end

  def clear_cache(client) do
    TypesenseEx.post(client, "/operations/cache/clear")
  end

  def compact_db(client) do
    TypesenseEx.post(client, "/operations/db/compact")
  end

  def config(client, body) do
    TypesenseEx.post(client, "/config", body)
  end
end

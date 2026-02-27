defmodule TypesenseEx.Operations do
  @moduledoc """
  Server-level administrative operations.

  Includes database snapshots, cache management, compaction, and configuration.
  """

  @doc "Returns the status of any in-progress schema changes."
  def schema_changes(client) do
    TypesenseEx.get(client, "/operations/schema_changes")
  end

  @doc """
  Creates a snapshot of the database at the given filesystem path.

  The `snapshot_path` must be an absolute path on the Typesense server.
  """
  def snapshot(client, snapshot_path) do
    TypesenseEx.post(client, "/operations/snapshot?snapshot_path=#{URI.encode(snapshot_path)}")
  end

  @doc "Triggers a Raft vote (used in clustered deployments)."
  def vote(client) do
    TypesenseEx.post(client, "/operations/vote")
  end

  @doc "Clears the search request cache."
  def clear_cache(client) do
    TypesenseEx.post(client, "/operations/cache/clear")
  end

  @doc "Compacts the on-disk database to reclaim space."
  def compact_db(client) do
    TypesenseEx.post(client, "/operations/db/compact")
  end

  @doc "Updates the server's runtime configuration."
  def config(client, body) do
    TypesenseEx.post(client, "/config", body)
  end
end

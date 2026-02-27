defmodule TypesenseEx.CurationSets do
  @moduledoc """
  Manage curation sets for fine-tuning search results.

  Curation sets let you manually promote or hide specific results for given queries,
  giving you control over search result ordering.
  """

  @doc "Lists all curation sets."
  def list(client), do: TypesenseEx.get(client, "/curation_sets")

  @doc "Retrieves a curation set by name."
  def get(client, name), do: TypesenseEx.get(client, "/curation_sets/#{name}")

  @doc "Creates or updates a curation set."
  def upsert(client, name, body), do: TypesenseEx.put(client, "/curation_sets/#{name}", body)

  @doc "Deletes a curation set."
  def delete(client, name), do: TypesenseEx.delete(client, "/curation_sets/#{name}")

  @doc "Lists all items in a curation set."
  def list_items(client, set_name) do
    TypesenseEx.get(client, "/curation_sets/#{set_name}/items")
  end

  @doc "Retrieves a specific item from a curation set."
  def get_item(client, set_name, item_id) do
    TypesenseEx.get(client, "/curation_sets/#{set_name}/items/#{item_id}")
  end

  @doc "Creates or updates an item in a curation set."
  def upsert_item(client, set_name, item_id, body) do
    TypesenseEx.put(client, "/curation_sets/#{set_name}/items/#{item_id}", body)
  end

  @doc "Deletes an item from a curation set."
  def delete_item(client, set_name, item_id) do
    TypesenseEx.delete(client, "/curation_sets/#{set_name}/items/#{item_id}")
  end
end

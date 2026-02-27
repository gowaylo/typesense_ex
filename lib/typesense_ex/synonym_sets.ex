defmodule TypesenseEx.SynonymSets do
  @moduledoc """
  Manage synonym sets for improved search recall.

  Synonym sets let you define groups of words that should be treated as equivalent
  during search (e.g., "sneakers" and "shoes").
  """

  @doc "Lists all synonym sets."
  def list(client), do: TypesenseEx.get(client, "/synonym_sets")

  @doc "Retrieves a synonym set by name."
  def get(client, name), do: TypesenseEx.get(client, "/synonym_sets/#{name}")

  @doc "Creates or updates a synonym set."
  def upsert(client, name, body), do: TypesenseEx.put(client, "/synonym_sets/#{name}", body)

  @doc "Deletes a synonym set."
  def delete(client, name), do: TypesenseEx.delete(client, "/synonym_sets/#{name}")

  @doc "Lists all items in a synonym set."
  def list_items(client, set_name) do
    TypesenseEx.get(client, "/synonym_sets/#{set_name}/items")
  end

  @doc "Retrieves a specific item from a synonym set."
  def get_item(client, set_name, item_id) do
    TypesenseEx.get(client, "/synonym_sets/#{set_name}/items/#{item_id}")
  end

  @doc "Creates or updates an item in a synonym set."
  def upsert_item(client, set_name, item_id, body) do
    TypesenseEx.put(client, "/synonym_sets/#{set_name}/items/#{item_id}", body)
  end

  @doc "Deletes an item from a synonym set."
  def delete_item(client, set_name, item_id) do
    TypesenseEx.delete(client, "/synonym_sets/#{set_name}/items/#{item_id}")
  end
end

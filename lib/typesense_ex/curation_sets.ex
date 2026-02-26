defmodule TypesenseEx.CurationSets do
  def list(client), do: TypesenseEx.get(client, "/curation_sets")

  def get(client, name), do: TypesenseEx.get(client, "/curation_sets/#{name}")

  def upsert(client, name, body), do: TypesenseEx.put(client, "/curation_sets/#{name}", body)

  def delete(client, name), do: TypesenseEx.delete(client, "/curation_sets/#{name}")

  def list_items(client, set_name) do
    TypesenseEx.get(client, "/curation_sets/#{set_name}/items")
  end

  def get_item(client, set_name, item_id) do
    TypesenseEx.get(client, "/curation_sets/#{set_name}/items/#{item_id}")
  end

  def upsert_item(client, set_name, item_id, body) do
    TypesenseEx.put(client, "/curation_sets/#{set_name}/items/#{item_id}", body)
  end

  def delete_item(client, set_name, item_id) do
    TypesenseEx.delete(client, "/curation_sets/#{set_name}/items/#{item_id}")
  end
end

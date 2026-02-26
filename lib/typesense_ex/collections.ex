defmodule TypesenseEx.Collections do
  def create(client, schema) do
    TypesenseEx.post(client, "/collections", schema)
  end

  def list(client) do
    TypesenseEx.get(client, "/collections")
  end

  def get(client, name) do
    TypesenseEx.get(client, "/collections/#{name}")
  end

  def update(client, name, updates) do
    TypesenseEx.patch(client, "/collections/#{name}", updates)
  end

  def delete(client, name) do
    TypesenseEx.delete(client, "/collections/#{name}")
  end
end

defmodule TypesenseEx.Collections do
  @moduledoc """
  Manage Typesense collections.

  Collections are the equivalent of tables in a relational database. Each collection
  has a schema that defines the fields and their types.

  ## Example

      schema = %{
        "name" => "books",
        "fields" => [
          %{"name" => "title", "type" => "string"},
          %{"name" => "author", "type" => "string", "facet" => true}
        ]
      }
      {:ok, collection} = TypesenseEx.Collections.create(client, schema)
  """

  @doc """
  Creates a new collection with the given schema.

  The schema map must include `"name"` and `"fields"`. See the
  [Typesense docs](https://typesense.org/docs/30.1/api/collections.html#create-a-collection)
  for all supported options.
  """
  def create(client, schema) do
    TypesenseEx.post(client, "/collections", schema)
  end

  @doc "Lists all collections."
  def list(client) do
    TypesenseEx.get(client, "/collections")
  end

  @doc "Retrieves a collection by name."
  def get(client, name) do
    TypesenseEx.get(client, "/collections/#{name}")
  end

  @doc """
  Updates a collection's schema (e.g., adding or dropping fields).

  Pass a map with a `"fields"` key containing the field changes.
  """
  def update(client, name, updates) do
    TypesenseEx.patch(client, "/collections/#{name}", updates)
  end

  @doc "Deletes a collection and all its documents."
  def delete(client, name) do
    TypesenseEx.delete(client, "/collections/#{name}")
  end
end

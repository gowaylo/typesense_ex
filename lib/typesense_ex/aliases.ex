defmodule TypesenseEx.Aliases do
  @moduledoc """
  Manage collection aliases.

  Aliases are virtual collection names that point to actual collections.
  They enable zero-downtime reindexing by swapping which collection an alias points to.

  ## Example

      # Point "books" alias to "books_v2" collection
      {:ok, _} = TypesenseEx.Aliases.upsert(client, "books", %{"collection_name" => "books_v2"})
  """

  @doc "Lists all aliases."
  def list(client), do: TypesenseEx.get(client, "/aliases")

  @doc "Retrieves an alias by name."
  def get(client, name), do: TypesenseEx.get(client, "/aliases/#{name}")

  @doc """
  Creates or updates an alias.

  The `body` map must contain `"collection_name"` pointing to the target collection.
  """
  def upsert(client, name, body), do: TypesenseEx.put(client, "/aliases/#{name}", body)

  @doc "Deletes an alias."
  def delete(client, name), do: TypesenseEx.delete(client, "/aliases/#{name}")
end

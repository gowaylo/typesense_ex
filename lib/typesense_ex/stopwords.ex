defmodule TypesenseEx.Stopwords do
  @moduledoc """
  Manage stopword sets.

  Stopwords are common words (e.g., "the", "and", "is") that can be ignored
  during search to improve relevance.
  """

  @doc "Lists all stopword sets."
  def list(client), do: TypesenseEx.get(client, "/stopwords")

  @doc "Retrieves a stopword set by ID."
  def get(client, set_id), do: TypesenseEx.get(client, "/stopwords/#{set_id}")

  @doc "Creates or updates a stopword set."
  def upsert(client, set_id, body), do: TypesenseEx.put(client, "/stopwords/#{set_id}", body)

  @doc "Deletes a stopword set by ID."
  def delete(client, set_id), do: TypesenseEx.delete(client, "/stopwords/#{set_id}")
end

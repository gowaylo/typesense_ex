defmodule TypesenseEx.NLSearchModels do
  @moduledoc """
  Manage natural language search models.

  NL search models enable semantic/vector search capabilities in Typesense,
  allowing searches based on meaning rather than exact keyword matches.
  """

  @doc "Lists all natural language search models."
  def list(client), do: TypesenseEx.get(client, "/nl_search_models")

  @doc "Retrieves a natural language search model by ID."
  def get(client, model_id), do: TypesenseEx.get(client, "/nl_search_models/#{model_id}")

  @doc "Creates a new natural language search model."
  def create(client, body), do: TypesenseEx.post(client, "/nl_search_models", body)

  @doc "Updates a natural language search model by ID."
  def update(client, model_id, body) do
    TypesenseEx.put(client, "/nl_search_models/#{model_id}", body)
  end

  @doc "Deletes a natural language search model by ID."
  def delete(client, model_id) do
    TypesenseEx.delete(client, "/nl_search_models/#{model_id}")
  end
end

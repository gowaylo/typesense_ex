defmodule TypesenseEx.Conversations do
  @moduledoc """
  Manage conversational AI search models.

  Conversation models enable RAG (Retrieval-Augmented Generation) powered
  conversational search on top of your Typesense collections.
  """

  @doc "Lists all conversation models."
  def list_models(client), do: TypesenseEx.get(client, "/conversations/models")

  @doc "Retrieves a conversation model by ID."
  def get_model(client, model_id) do
    TypesenseEx.get(client, "/conversations/models/#{model_id}")
  end

  @doc "Creates a new conversation model."
  def create_model(client, body) do
    TypesenseEx.post(client, "/conversations/models", body)
  end

  @doc "Updates a conversation model by ID."
  def update_model(client, model_id, body) do
    TypesenseEx.put(client, "/conversations/models/#{model_id}", body)
  end

  @doc "Deletes a conversation model by ID."
  def delete_model(client, model_id) do
    TypesenseEx.delete(client, "/conversations/models/#{model_id}")
  end
end

defmodule TypesenseEx.Conversations do
  def list_models(client), do: TypesenseEx.get(client, "/conversations/models")

  def get_model(client, model_id) do
    TypesenseEx.get(client, "/conversations/models/#{model_id}")
  end

  def create_model(client, body) do
    TypesenseEx.post(client, "/conversations/models", body)
  end

  def update_model(client, model_id, body) do
    TypesenseEx.put(client, "/conversations/models/#{model_id}", body)
  end

  def delete_model(client, model_id) do
    TypesenseEx.delete(client, "/conversations/models/#{model_id}")
  end
end

defmodule TypesenseEx.NLSearchModels do
  def list(client), do: TypesenseEx.get(client, "/nl_search_models")

  def get(client, model_id), do: TypesenseEx.get(client, "/nl_search_models/#{model_id}")

  def create(client, body), do: TypesenseEx.post(client, "/nl_search_models", body)

  def update(client, model_id, body) do
    TypesenseEx.put(client, "/nl_search_models/#{model_id}", body)
  end

  def delete(client, model_id) do
    TypesenseEx.delete(client, "/nl_search_models/#{model_id}")
  end
end

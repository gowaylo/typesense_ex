defmodule TypesenseEx.Search do
  def search(client, collection, params) do
    TypesenseEx.get(client, "/collections/#{collection}/documents/search", Map.to_list(params))
  end

  def multi_search(client, body) do
    TypesenseEx.post(client, "/multi_search", body)
  end
end

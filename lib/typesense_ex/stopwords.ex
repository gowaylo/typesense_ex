defmodule TypesenseEx.Stopwords do
  def list(client), do: TypesenseEx.get(client, "/stopwords")

  def get(client, set_id), do: TypesenseEx.get(client, "/stopwords/#{set_id}")

  def upsert(client, set_id, body), do: TypesenseEx.put(client, "/stopwords/#{set_id}", body)

  def delete(client, set_id), do: TypesenseEx.delete(client, "/stopwords/#{set_id}")
end

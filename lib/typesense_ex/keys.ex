defmodule TypesenseEx.Keys do
  def list(client), do: TypesenseEx.get(client, "/keys")

  def create(client, key_schema), do: TypesenseEx.post(client, "/keys", key_schema)

  def get(client, key_id), do: TypesenseEx.get(client, "/keys/#{key_id}")

  def delete(client, key_id), do: TypesenseEx.delete(client, "/keys/#{key_id}")
end

defmodule TypesenseEx.Aliases do
  def list(client), do: TypesenseEx.get(client, "/aliases")

  def get(client, name), do: TypesenseEx.get(client, "/aliases/#{name}")

  def upsert(client, name, body), do: TypesenseEx.put(client, "/aliases/#{name}", body)

  def delete(client, name), do: TypesenseEx.delete(client, "/aliases/#{name}")
end

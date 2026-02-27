defmodule TypesenseEx.Keys do
  @moduledoc """
  Manage API keys with fine-grained access control.

  API keys can restrict access to specific collections and actions.

  ## Example

      {:ok, key} = TypesenseEx.Keys.create(client, %{
        "description" => "Search-only key",
        "actions" => ["documents:search"],
        "collections" => ["books"]
      })
  """

  @doc "Lists all API keys (key values are redacted)."
  def list(client), do: TypesenseEx.get(client, "/keys")

  @doc """
  Creates a new API key.

  The schema should include `"actions"` and `"collections"` to define the key's permissions.
  """
  def create(client, key_schema), do: TypesenseEx.post(client, "/keys", key_schema)

  @doc "Retrieves an API key by its numeric ID (value is redacted)."
  def get(client, key_id), do: TypesenseEx.get(client, "/keys/#{key_id}")

  @doc "Deletes an API key by its numeric ID."
  def delete(client, key_id), do: TypesenseEx.delete(client, "/keys/#{key_id}")
end

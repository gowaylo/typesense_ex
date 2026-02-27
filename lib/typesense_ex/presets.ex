defmodule TypesenseEx.Presets do
  @moduledoc """
  Manage search presets.

  Presets let you save and reuse common search configurations, reducing
  the amount of parameters you need to pass on each search request.
  """

  @doc "Lists all search presets."
  def list(client), do: TypesenseEx.get(client, "/presets")

  @doc "Retrieves a search preset by ID."
  def get(client, preset_id), do: TypesenseEx.get(client, "/presets/#{preset_id}")

  @doc "Creates or updates a search preset."
  def upsert(client, preset_id, body), do: TypesenseEx.put(client, "/presets/#{preset_id}", body)

  @doc "Deletes a search preset by ID."
  def delete(client, preset_id), do: TypesenseEx.delete(client, "/presets/#{preset_id}")
end

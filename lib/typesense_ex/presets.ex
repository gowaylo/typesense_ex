defmodule TypesenseEx.Presets do
  def list(client), do: TypesenseEx.get(client, "/presets")

  def get(client, preset_id), do: TypesenseEx.get(client, "/presets/#{preset_id}")

  def upsert(client, preset_id, body), do: TypesenseEx.put(client, "/presets/#{preset_id}", body)

  def delete(client, preset_id), do: TypesenseEx.delete(client, "/presets/#{preset_id}")
end

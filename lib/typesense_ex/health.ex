defmodule TypesenseEx.Health do
  def health(client), do: TypesenseEx.get(client, "/health")

  def debug(client), do: TypesenseEx.get(client, "/debug")

  def metrics(client), do: TypesenseEx.get(client, "/metrics.json")

  def stats(client), do: TypesenseEx.get(client, "/stats.json")
end

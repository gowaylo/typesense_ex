defmodule TypesenseEx.Health do
  @moduledoc """
  Server health, debug info, metrics, and API stats.

  ## Example

      {:ok, %{"ok" => true}} = TypesenseEx.Health.health(client)
      {:ok, debug} = TypesenseEx.Health.debug(client)
  """

  @doc "Returns the health status of the Typesense server."
  def health(client), do: TypesenseEx.get(client, "/health")

  @doc "Returns debug information including the server version."
  def debug(client), do: TypesenseEx.get(client, "/debug")

  @doc "Returns server metrics (CPU, memory, disk usage, etc.)."
  def metrics(client), do: TypesenseEx.get(client, "/metrics.json")

  @doc "Returns API request statistics."
  def stats(client), do: TypesenseEx.get(client, "/stats.json")
end

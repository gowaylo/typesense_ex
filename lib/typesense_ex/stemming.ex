defmodule TypesenseEx.Stemming do
  @moduledoc """
  Manage stemming dictionaries.

  Stemming dictionaries allow you to define custom word-to-stem mappings,
  so that different word forms (e.g., "running", "ran") map to the same root.
  """

  @doc "Lists all stemming dictionaries."
  def list_dictionaries(client) do
    TypesenseEx.get(client, "/stemming/dictionaries")
  end

  @doc "Retrieves a stemming dictionary by ID."
  def get_dictionary(client, dictionary_id) do
    TypesenseEx.get(client, "/stemming/dictionaries/#{dictionary_id}")
  end

  @doc """
  Imports words into a stemming dictionary using JSONL format.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `dictionary_id` - The dictionary identifier
    * `words` - A list of word maps (e.g., `[%{"word" => "running", "root" => "run"}]`)
  """
  def import_dictionary(client, dictionary_id, words) do
    jsonl =
      words
      |> Enum.map(&Jason.encode!/1)
      |> Enum.join("\n")

    req =
      Req.new(
        base_url: client.base_url,
        headers: [
          {"x-typesense-api-key", client.api_key},
          {"content-type", "text/plain"}
        ]
      )

    case Req.post(req, url: "/stemming/dictionaries/import", body: jsonl, params: [id: dictionary_id]) do
      {:ok, %Req.Response{status: status, body: body}} when status in 200..299 ->
        {:ok, body}

      {:ok, %Req.Response{body: body}} ->
        {:error, body}

      {:error, reason} ->
        {:error, reason}
    end
  end
end

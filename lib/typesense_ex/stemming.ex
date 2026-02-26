defmodule TypesenseEx.Stemming do
  def list_dictionaries(client) do
    TypesenseEx.get(client, "/stemming/dictionaries")
  end

  def get_dictionary(client, dictionary_id) do
    TypesenseEx.get(client, "/stemming/dictionaries/#{dictionary_id}")
  end

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

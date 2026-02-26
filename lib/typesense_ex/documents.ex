defmodule TypesenseEx.Documents do
  def index(client, collection, document) do
    TypesenseEx.post(client, "/collections/#{collection}/documents", document)
  end

  def get(client, collection, document_id) do
    TypesenseEx.get(client, "/collections/#{collection}/documents/#{document_id}")
  end

  def update(client, collection, document_id, updates) do
    TypesenseEx.patch(client, "/collections/#{collection}/documents/#{document_id}", updates)
  end

  def delete(client, collection, document_id) do
    TypesenseEx.delete(client, "/collections/#{collection}/documents/#{document_id}")
  end

  def import(client, collection, documents, params \\ []) do
    jsonl =
      documents
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

    case Req.post(req, url: "/collections/#{collection}/documents/import", body: jsonl, params: params) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        results =
          body
          |> String.split("\n", trim: true)
          |> Enum.map(&Jason.decode!/1)

        {:ok, results}

      {:ok, %Req.Response{body: body}} ->
        {:error, body}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def export(client, collection, params \\ []) do
    req =
      Req.new(
        base_url: client.base_url,
        headers: [{"x-typesense-api-key", client.api_key}],
        decode_body: false
      )

    case Req.get(req, url: "/collections/#{collection}/documents/export", params: params) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        docs =
          body
          |> String.split("\n", trim: true)
          |> Enum.map(&Jason.decode!/1)

        {:ok, docs}

      {:ok, %Req.Response{body: body}} ->
        {:error, body}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def update_by_filter(client, collection, updates, filter_by) do
    TypesenseEx.patch(client, "/collections/#{collection}/documents?filter_by=#{URI.encode(filter_by)}", updates)
  end

  def delete_by_filter(client, collection, filter_by, params \\ []) do
    TypesenseEx.delete(client, "/collections/#{collection}/documents", [{:filter_by, filter_by} | params])
  end
end

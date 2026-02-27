defmodule TypesenseEx.Documents do
  @moduledoc """
  Index, retrieve, update, delete, and bulk-manage documents in a Typesense collection.

  ## Single document operations

      {:ok, doc} = Documents.index(client, "books", %{"title" => "Dune", "year" => 1965})
      {:ok, doc} = Documents.get(client, "books", "0")
      {:ok, doc} = Documents.update(client, "books", "0", %{"year" => 1966})
      {:ok, _}   = Documents.delete(client, "books", "0")

  ## Bulk operations

      {:ok, results} = Documents.import(client, "books", [doc1, doc2])
      {:ok, docs}    = Documents.export(client, "books")
  """

  @doc """
  Indexes a single document into the collection.

  The document map should contain fields matching the collection schema.
  """
  def index(client, collection, document) do
    TypesenseEx.post(client, "/collections/#{collection}/documents", document)
  end

  @doc "Retrieves a document by its ID."
  def get(client, collection, document_id) do
    TypesenseEx.get(client, "/collections/#{collection}/documents/#{document_id}")
  end

  @doc "Partially updates a document by its ID."
  def update(client, collection, document_id, updates) do
    TypesenseEx.patch(client, "/collections/#{collection}/documents/#{document_id}", updates)
  end

  @doc "Deletes a document by its ID."
  def delete(client, collection, document_id) do
    TypesenseEx.delete(client, "/collections/#{collection}/documents/#{document_id}")
  end

  @doc """
  Bulk-imports a list of documents into a collection using JSONL format.

  Returns a list of result maps indicating the success/failure of each document.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `collection` - The collection name
    * `documents` - A list of document maps
    * `params` - Optional query parameters (e.g., `[action: "upsert"]`)
  """
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

  @doc """
  Exports all documents from a collection as a list of maps.

  Uses JSONL format internally and returns the parsed list.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `collection` - The collection name
    * `params` - Optional query parameters (e.g., `[filter_by: "year:>1950"]`)
  """
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

  @doc """
  Updates documents matching the given filter expression.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `collection` - The collection name
    * `updates` - A map of field updates to apply
    * `filter_by` - A Typesense filter expression (e.g., `"year:>1950"`)
  """
  def update_by_filter(client, collection, updates, filter_by) do
    TypesenseEx.patch(client, "/collections/#{collection}/documents?filter_by=#{URI.encode(filter_by)}", updates)
  end

  @doc """
  Deletes documents matching the given filter expression.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `collection` - The collection name
    * `filter_by` - A Typesense filter expression (e.g., `"year:>1950"`)
    * `params` - Optional additional query parameters
  """
  def delete_by_filter(client, collection, filter_by, params \\ []) do
    TypesenseEx.delete(client, "/collections/#{collection}/documents", [{:filter_by, filter_by} | params])
  end
end

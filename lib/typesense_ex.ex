defmodule TypesenseEx do
  @moduledoc """
  HTTP client for the Typesense search engine API.

  Provides low-level HTTP methods (`get/3`, `post/3`, `put/3`, `patch/3`, `delete/3`)
  used by the higher-level feature modules. Most users should use the feature modules
  directly (e.g., `TypesenseEx.Collections`, `TypesenseEx.Documents`, `TypesenseEx.Search`).

  ## Creating a client

      client = TypesenseEx.new("http://localhost:8108", "your-api-key")

  The client struct is passed to all API functions.

  ## Response format

  All API functions return `{:ok, body}` on success (HTTP 2xx) or `{:error, reason}` on failure.
  """

  defstruct [:base_url, :api_key]

  @doc """
  Creates a new Typesense client.

  ## Parameters

    * `base_url` - The base URL of the Typesense server (e.g., `"http://localhost:8108"`)
    * `api_key` - The API key for authentication

  ## Examples

      iex> client = TypesenseEx.new("http://localhost:8108", "xyz")
      %TypesenseEx{base_url: "http://localhost:8108", api_key: "xyz"}
  """
  def new(base_url, api_key) do
    %__MODULE__{base_url: base_url, api_key: api_key}
  end

  @doc """
  Sends an HTTP GET request.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `path` - The API endpoint path (e.g., `"/collections"`)
    * `params` - Optional query parameters as a keyword list
  """
  def get(client, path, params \\ []) do
    client
    |> build_req()
    |> Req.get(url: path, params: params)
    |> handle_response()
  end

  @doc """
  Sends an HTTP POST request with a JSON body.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `path` - The API endpoint path
    * `body` - The request body (will be JSON-encoded)
  """
  def post(client, path, body \\ nil) do
    client
    |> build_req()
    |> Req.post(url: path, json: body)
    |> handle_response()
  end

  @doc """
  Sends an HTTP PUT request with a JSON body.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `path` - The API endpoint path
    * `body` - The request body (will be JSON-encoded)
  """
  def put(client, path, body \\ nil) do
    client
    |> build_req()
    |> Req.put(url: path, json: body)
    |> handle_response()
  end

  @doc """
  Sends an HTTP PATCH request with a JSON body.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `path` - The API endpoint path
    * `body` - The request body (will be JSON-encoded)
  """
  def patch(client, path, body \\ nil) do
    client
    |> build_req()
    |> Req.patch(url: path, json: body)
    |> handle_response()
  end

  @doc """
  Sends an HTTP DELETE request.

  ## Parameters

    * `client` - A `%TypesenseEx{}` client struct
    * `path` - The API endpoint path
    * `params` - Optional query parameters as a keyword list
  """
  def delete(client, path, params \\ []) do
    client
    |> build_req()
    |> Req.delete(url: path, params: params)
    |> handle_response()
  end

  defp build_req(client) do
    Req.new(
      base_url: client.base_url,
      headers: [{"x-typesense-api-key", client.api_key}]
    )
  end

  defp handle_response({:ok, %Req.Response{status: status, body: body}})
       when status in 200..299 do
    {:ok, body}
  end

  defp handle_response({:ok, %Req.Response{body: body}}) do
    {:error, body}
  end

  defp handle_response({:error, reason}) do
    {:error, reason}
  end
end

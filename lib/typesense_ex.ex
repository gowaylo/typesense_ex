defmodule TypesenseEx do
  @moduledoc """
  Typesense API client for Elixir.
  """

  defstruct [:base_url, :api_key]

  def new(base_url, api_key) do
    %__MODULE__{base_url: base_url, api_key: api_key}
  end

  def get(client, path, params \\ []) do
    client
    |> build_req()
    |> Req.get(url: path, params: params)
    |> handle_response()
  end

  def post(client, path, body \\ nil) do
    client
    |> build_req()
    |> Req.post(url: path, json: body)
    |> handle_response()
  end

  def put(client, path, body \\ nil) do
    client
    |> build_req()
    |> Req.put(url: path, json: body)
    |> handle_response()
  end

  def patch(client, path, body \\ nil) do
    client
    |> build_req()
    |> Req.patch(url: path, json: body)
    |> handle_response()
  end

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

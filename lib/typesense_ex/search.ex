defmodule TypesenseEx.Search do
  @moduledoc """
  Full-text search operations.

  ## Example

      {:ok, results} = TypesenseEx.Search.search(client, "books", %{
        "q" => "gatsby",
        "query_by" => "title,author",
        "filter_by" => "year:>1920",
        "sort_by" => "year:desc"
      })

  ## Common search parameters

    * `"q"` - The query text
    * `"query_by"` - Comma-separated list of fields to search
    * `"filter_by"` - Filter expression (e.g., `"year:>1950 && author:Orwell"`)
    * `"sort_by"` - Sort expression (e.g., `"year:desc"`)
    * `"facet_by"` - Comma-separated list of fields to facet on
    * `"per_page"` - Number of results per page
    * `"page"` - Page number

  See the [Typesense search docs](https://typesense.org/docs/30.1/api/search.html) for all options.
  """

  @doc """
  Searches a collection with the given parameters.

  `params` is a map of search parameters that will be sent as query parameters.
  """
  def search(client, collection, params) do
    TypesenseEx.get(client, "/collections/#{collection}/documents/search", Map.to_list(params))
  end

  @doc """
  Executes multiple searches in a single request.

  The `body` map should contain a `"searches"` key with a list of search objects,
  each specifying a `"collection"` and search parameters.

  ## Example

      TypesenseEx.Search.multi_search(client, %{
        "searches" => [
          %{"collection" => "books", "q" => "gatsby", "query_by" => "title"},
          %{"collection" => "movies", "q" => "gatsby", "query_by" => "title"}
        ]
      })
  """
  def multi_search(client, body) do
    TypesenseEx.post(client, "/multi_search", body)
  end
end

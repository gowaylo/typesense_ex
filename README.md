# TypesenseEx

An Elixir client for the [Typesense](https://typesense.org/) search engine API (v30.1).

Typesense is a fast, typo-tolerant search engine optimized for instant search experiences. This library provides a complete Elixir wrapper for the Typesense HTTP API.

## Installation

Add `typesense_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:typesense_ex, "~> 0.1.0"}
  ]
end
```

## Usage

### Creating a client

All operations require a `TypesenseEx` client struct:

```elixir
client = TypesenseEx.new("http://localhost:8108", "your-api-key")
```

### Collections

Collections are the equivalent of tables in a relational database. You define a schema and then index documents into the collection.

```elixir
alias TypesenseEx.Collections

# Create a collection
schema = %{
  "name" => "books",
  "fields" => [
    %{"name" => "title", "type" => "string"},
    %{"name" => "author", "type" => "string", "facet" => true},
    %{"name" => "year", "type" => "int32", "facet" => true}
  ],
  "default_sorting_field" => "year"
}

{:ok, collection} = Collections.create(client, schema)

# List all collections
{:ok, collections} = Collections.list(client)

# Get a collection
{:ok, collection} = Collections.get(client, "books")

# Update a collection (add/drop fields)
{:ok, updated} = Collections.update(client, "books", %{
  "fields" => [%{"name" => "publisher", "type" => "string"}]
})

# Delete a collection
{:ok, _} = Collections.delete(client, "books")
```

### Documents

Index, retrieve, update, and delete individual documents or in bulk.

```elixir
alias TypesenseEx.Documents

# Index a single document
{:ok, doc} = Documents.index(client, "books", %{
  "title" => "The Great Gatsby",
  "author" => "F. Scott Fitzgerald",
  "year" => 1925
})

# Get a document by ID
{:ok, doc} = Documents.get(client, "books", "0")

# Update a document
{:ok, doc} = Documents.update(client, "books", "0", %{"year" => 1926})

# Delete a document
{:ok, _} = Documents.delete(client, "books", "0")

# Bulk import
documents = [
  %{"title" => "1984", "author" => "George Orwell", "year" => 1949},
  %{"title" => "Dune", "author" => "Frank Herbert", "year" => 1965}
]
{:ok, results} = Documents.import(client, "books", documents)

# Export all documents
{:ok, docs} = Documents.export(client, "books")

# Update documents matching a filter
{:ok, _} = Documents.update_by_filter(client, "books", %{"author" => "Updated"}, "year:>1950")

# Delete documents matching a filter
{:ok, _} = Documents.delete_by_filter(client, "books", "year:>1950")
```

### Search

Perform full-text search with filtering, faceting, and sorting.

```elixir
alias TypesenseEx.Search

# Search for documents
{:ok, results} = Search.search(client, "books", %{
  "q" => "gatsby",
  "query_by" => "title,author"
})

# Search with filters and facets
{:ok, results} = Search.search(client, "books", %{
  "q" => "fiction",
  "query_by" => "title",
  "filter_by" => "year:>1950",
  "facet_by" => "author",
  "sort_by" => "year:desc"
})

# Multi-search (multiple searches in one request)
{:ok, results} = Search.multi_search(client, %{
  "searches" => [
    %{"collection" => "books", "q" => "gatsby", "query_by" => "title"},
    %{"collection" => "books", "q" => "orwell", "query_by" => "author"}
  ]
})
```

### Aliases

Create virtual collection names that point to actual collections. Useful for zero-downtime reindexing.

```elixir
alias TypesenseEx.Aliases

{:ok, _} = Aliases.upsert(client, "books", %{"collection_name" => "books_v2"})
{:ok, aliases} = Aliases.list(client)
{:ok, alias_info} = Aliases.get(client, "books")
{:ok, _} = Aliases.delete(client, "books")
```

### API Keys

Create and manage API keys with fine-grained access control.

```elixir
alias TypesenseEx.Keys

{:ok, key} = Keys.create(client, %{
  "description" => "Search-only key",
  "actions" => ["documents:search"],
  "collections" => ["books"]
})

{:ok, keys} = Keys.list(client)
{:ok, key} = Keys.get(client, 1)
{:ok, _} = Keys.delete(client, 1)
```

### Analytics

Track search analytics, create rules, and log events.

```elixir
alias TypesenseEx.Analytics

{:ok, rule} = Analytics.create_rule(client, %{
  "name" => "search_queries",
  "type" => "popular_queries",
  "params" => %{"source" => %{"collections" => ["books"]}}
})

{:ok, _} = Analytics.create_event(client, %{
  "type" => "search",
  "data" => %{"q" => "gatsby"}
})

{:ok, rules} = Analytics.list_rules(client)
{:ok, status} = Analytics.status(client)
```

### Health & Operations

Monitor server health and perform administrative operations.

```elixir
alias TypesenseEx.Health
alias TypesenseEx.Operations

# Health checks
{:ok, health} = Health.health(client)
{:ok, debug} = Health.debug(client)
{:ok, metrics} = Health.metrics(client)
{:ok, stats} = Health.stats(client)

# Server operations
{:ok, _} = Operations.clear_cache(client)
{:ok, _} = Operations.compact_db(client)
{:ok, _} = Operations.snapshot(client, "/tmp/typesense-snapshot")
```

### Additional Features

- **Presets** (`TypesenseEx.Presets`) - Save and reuse search configurations
- **Stopwords** (`TypesenseEx.Stopwords`) - Manage stopword sets to ignore common words
- **Stemming** (`TypesenseEx.Stemming`) - Configure stemming dictionaries for linguistic matching
- **Synonym Sets** (`TypesenseEx.SynonymSets`) - Define word synonyms for better search recall
- **Curation Sets** (`TypesenseEx.CurationSets`) - Manually curate search results
- **Conversations** (`TypesenseEx.Conversations`) - Manage conversational AI search models
- **NL Search Models** (`TypesenseEx.NLSearchModels`) - Configure natural language search models

## Response Format

All functions return `{:ok, result}` on success or `{:error, reason}` on failure:

```elixir
case TypesenseEx.Collections.get(client, "books") do
  {:ok, collection} -> IO.inspect(collection)
  {:error, %{"message" => msg}} -> IO.puts("Error: #{msg}")
end
```

## Requirements

- Elixir ~> 1.18
- A running [Typesense](https://typesense.org/docs/guide/install-typesense.html) server (v30.1+)

## Documentation

Generate the docs locally with:

```bash
mix docs
```

## License

[MIT](LICENSE)

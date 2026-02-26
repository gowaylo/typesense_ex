defmodule TypesenseExTest do
  use ExUnit.Case

  test "new/2 creates a client struct" do
    client = TypesenseEx.new("http://localhost:8108", "xyz")
    assert %TypesenseEx{base_url: "http://localhost:8108", api_key: "xyz"} = client
  end
end

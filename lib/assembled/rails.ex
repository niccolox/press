defmodule Assembled.Rails do
  @domain "https://assembled.app"

  def index(class, session) do
    (@domain <> "/measures.json")
    |> URI.parse
    |> Map.put(:query, URI.encode_query(%{ class: class, session: session }))
    |> URI.to_string
    |> HTTPoison.get!([], [recv_timeout: 60000])
    |> Map.get(:body)
    |> Poison.decode!
  end
end

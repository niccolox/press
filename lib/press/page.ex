defmodule Press.Page do
  @enforce_keys [:key, :composer, :name, :body, :summary, :labels, :day]
  defstruct [:key, :composer, :name, :body, :summary, :labels, :day]

  def build(node, angles, body) do
    [clock, key] = (
      node
      |> Path.rootname |> Path.split |> List.last
      |> String.split(".", parts: 2)
    )
    struct!(__MODULE__, [
      key: key,
      day: Date.from_iso8601!(clock),
      body: body,
    ] ++ Map.to_list(angles))
  end
end

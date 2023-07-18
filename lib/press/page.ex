defmodule Press.Page do
  @enforce_keys [:key, :composer, :name, :body, :summary, :labels, :day]
  defstruct [:key, :composer, :name, :body, :summary, :labels, :day]

  def build(node, angles, body) do
    # import IEx; IEx.pry
    [node_name] = node |> Path.rootname |> Path.split |> Enum.take(-1)
    [clock, key] = node_name |> String.split(".", parts: 2)
    day = Date.from_iso8601!(clock)
    struct!(__MODULE__, [key: key, day: day, body: body] ++ Map.to_list(angles))
  end
end

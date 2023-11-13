defmodule Record.US.Congress do
  @angles (~w[ index titles text summaries subjects
    relatedBills cosponsors committees amendments actions ]a
    |> Enum.reduce(%{ :text => :textVersions }, fn x, sum ->
      Map.update(sum, x, x, & &1)
    end))

  def sessions do
    (System.get_env("MEASURE_ADDRESS") <> "/session/*")
    |> Path.wildcard
    |> Enum.map(&Path.basename/1)
    |> Enum.map(&String.to_integer/1)
  end

  @doc"""
  record = Record.US.Congress.bills_in(99) |> hd
  """
  def bills_in session do
    (System.get_env("MEASURE_ADDRESS") <> "/session/#{session}/bill/*")
    |> Path.wildcard
    |> Enum.map(&Path.basename/1)
    |> Enum.map(& String.split(&1, "."))
    |> Enum.reduce(%{}, fn [bill, clock], sum ->
      Map.update(sum, "/session/#{session}/bill/#{bill}", clock, &(if &1 < clock, do: clock, else: &1))
    end) |> Map.to_list
    |> Enum.map(& &1 |> Tuple.to_list |> Enum.join("."))
  end

  @doc"""
  # Example has 264 cosponsors.
  rec = Record.US.Congress.read "/session/118/bill/hr82.2023-03-17T17-45-42Z"
  """
  def read record do
    @angles |> Map.keys |> Enum.map(fn angle ->
      nodes = (System.get_env("MEASURE_ADDRESS") <> record <> "/#{angle}.*.json"
      ) |> Path.wildcard |> Enum.sort |> IO.inspect

      { angle,
        nodes |> Enum.map(fn node ->
          (File.read(node) |> elem(1) |> Jason.decode! |> Map.drop(~w[request pagination]))[@angles[angle] |> Atom.to_string]
        end) |> merge
      }
    end)
  end

  defp merge([]), do: []
  defp merge([a]), do: a
  defp merge([a,b]) when is_list(a) when is_list(b), do: a ++ b
  defp merge([a,b]), do: DeepMerge.deep_merge(a, b)
  defp merge([a,b | remainder]), do: merge(List.flatten([merge([a, b])]) ++ remainder)
end

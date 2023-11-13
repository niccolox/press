defmodule Record.US.Congress do
  @doc"""
  Record.US.Congress.bills_in(99) |> Map.to_enum
  """

  def sessions do
    (System.get_env("MEASURE_ADDRESS") <> "/session/*")
    |> Path.wildcard
    |> Enum.map(&Path.basename/1)
    |> Enum.map(&String.to_integer/1)
  end

  def bills_in session do
    (System.get_env("MEASURE_ADDRESS") <> "/session/#{session}/bill/*")
    |> Path.wildcard
    |> Enum.map(&Path.basename/1)
    |> Enum.map(& String.split(&1, "."))
    |> Enum.reduce(%{}, fn [bill, clock], sum ->
      Map.update(sum, bill, clock, &(if &1 < clock, do: clock, else: &1))
    end)
    |> Map.to_list
  end
end

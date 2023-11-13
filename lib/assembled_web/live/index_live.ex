defmodule AssembledWeb.IndexLive do
  use Surface.LiveView

  data index, :map, default: %{}

  def mount _, _, socket do
    idx = Assembled.Rails.index("hconres", 110) |> Enum.map(fn {_,m} -> m end)
    { :ok, socket |> assign(:index, idx) }
  end
end

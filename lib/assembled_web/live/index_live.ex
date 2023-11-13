defmodule AssembledWeb.IndexLive do
  use Surface.LiveView
  alias AssembledWeb.Components.Choice

  data index, :map, default: %{}
  data classes, :list, default: ~w[ hr s ]

  data sessions, :list, default: [ 118 ]
  data possible_classes, :list, default: ~w[ hr s hconres sconres hjres sjres hres sres ]

  def handle_event "press_class", %{"value" => choice}, socket do
    choice |> IO.inspect
    classes = socket.assigns[:classes] |> IO.inspect
    classes = if Enum.member?(classes, choice),
      do: classes -- [choice],
      else: classes ++ [choice]
    classes |> IO.inspect

    { :noreply, socket |> assign(:classes, classes) }
  end

  def mount _params, _session, socket do
    idx = Assembled.Rails.index("hconres", 110) |> Enum.map(fn {_,m} -> m end)
    { :ok, socket |> assign(:index, idx) }
  end
end

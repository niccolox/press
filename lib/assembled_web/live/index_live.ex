defmodule AssembledWeb.IndexLive do
  use Surface.LiveView
  alias AssembledWeb.Components.Choice
  alias Record.US.Congress

  data assembled_index, :list, default: []
  data index, :map, default: %{}

  data sessions, :list, default: [ 118 ]
  data possible_sessions, :list, default: []
  data classes, :list, default: ~w[ hr s ]
  data possible_classes, :list, default: ~w[ hr s hconres sconres hjres sjres hres sres ]

  def handle_event "press_class", %{"value" => choice}, socket do
    classes = socket.assigns[:classes]
    { :noreply, socket
    |> assign(:classes, case Enum.member?(classes, choice) do
      true -> classes -- [choice]
      false -> classes ++ [choice]
    end) }
  end

  def mount _params, _session, socket do
    { :ok, socket
    |> assign(:assembled_index, Assembled.Rails.index("hconres", 110) |> Enum.map(fn {_,m} -> m end))
    |> assign(:possible_sessions, Congress.sessions |> Enum.sort |> Enum.reverse)
    }
  end
end

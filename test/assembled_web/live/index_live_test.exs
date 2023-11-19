defmodule AssembledWeb.IndexLiveTest do
  use ExUnit.Case, async: true
  alias AssembledWeb.IndexLive

  defp load(), do: %{socket: %Phoenix.LiveView.Socket{}}

  describe "On load" do
    setup do load() end

    test "...", %{socket: socket} do
    end
  end
end

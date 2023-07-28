defmodule AssembledWeb.Components.CardTest do
  use AssembledWeb.ConnCase, async: true
  use Surface.LiveViewTest

  catalogue_test AssembledWeb.Card
end

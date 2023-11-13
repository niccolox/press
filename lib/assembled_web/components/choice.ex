defmodule AssembledWeb.Components.Choice do
  use Surface.Component
  alias SurfaceBulma.Button

  prop options, :list, default: []
  prop choose, :event
  prop labels, :map, default: %{}
  prop class, :css_class
  prop disabled, :list, default: []
  prop choices, :list, default: []

  slot default
end

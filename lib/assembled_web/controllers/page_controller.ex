defmodule AssembledWeb.PageController do
  use AssembledWeb, :controller

  def home(conn, _params) do render(conn, :home, layout: false) end
  def corp(conn, _params) do render(conn, :corp, layout: false) end
end

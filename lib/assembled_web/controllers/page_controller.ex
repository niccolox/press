defmodule AssembledWeb.PageController do
  use AssembledWeb, :controller

  def index(conn, _params) do
    render(conn, :index, layout: false, pages: Press.all_pages())
  end

  def show(conn, %{ "key" => key }) do
    render(conn, :show, layout: false, page: Press.page_by_key!(key))
  end

  def home(conn, _params) do render(conn, :home, layout: false) end
  def corp(conn, _params) do render(conn, :corp, layout: false) end
end

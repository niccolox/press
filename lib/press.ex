defmodule Press do
  use NimblePublisher, build: Press.Page, as: :pages,
    from: Application.app_dir(:assembled, "priv/pages/*.md"),
    highlighters: [:makeup_elixir, :makeup_erlang]

  @pages Enum.sort_by(@pages, & &1.day, {:desc, Date})
  @labels @pages |> Enum.flat_map(& &1.labels) |> Enum.uniq |> Enum.sort
  def all_pages, do: @pages
  def all_labels, do: @labels

  defmodule NotFoundError, do: defexception [:message, plug_status: 404]

  def page_by_key!(key) do
    Enum.find(all_pages(), &(&1.key == key)) ||
      raise NotFoundError, "no page is marked by key = `#{key}`."
  end

  def pages_by_label!(label) do
    case Enum.filter(all_pages(), &(label in &1.labels)) do
      [] -> raise NotFoundError, "No pages are labeled as `#{label}`."
      pages -> pages
    end
  end
end

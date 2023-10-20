defmodule AssembledWeb.IndexLive do
  use Surface.LiveView

  data index, :map, default: %{}

  def mount _, _, socket do
    idx = Assembled.Rails.index("hconres", 110) |> Enum.map(fn {_,m} -> m end)
    { :ok, socket |> assign(:index, idx) }
  end

  def render(assigns) do
    ~F"""
    <style>
      .measure {
        margin-bottom: 2rem;
        border: 4px solid #2d2d2d;
        border-radius: 8px;
        padding: 2rem;
        background: #c09999;
        color: #062743;
      }
    </style>

    <h1><a href="/home">Assembled Index</a></h1>

    {#for measure <- @index}
      <div class="measure">
        <h2>
          {measure["angles"]["index"]["congress"]}
          {measure["angles"]["index"]["type"]}
          {measure["angles"]["index"]["number"]}
        </h2>
        <code>{measure |> Poison.encode!}</code>
      </div>
    {/for}
    """
  end
end

defmodule AssembledWeb.Layouts do
  use AssembledWeb, :html

  embed_templates "layouts/*"
  embed_sface "layouts/root.sface"
  embed_sface "layouts/app.sface"
end

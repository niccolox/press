defmodule Assembled.Human.Alias do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "human_aliases" do
    field :name, :string
    field :legal_name, :string
    field :human_key, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(alias, attrs) do
    alias
    |> cast(attrs, [:name, :legal_name])
    |> validate_required([:name])
  end
end

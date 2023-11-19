defmodule Assembled.Human do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "humans" do
    field :enabled, {:array, :utc_datetime}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(human, attrs) do
    human
    |> cast(attrs, [:enabled])
    |> validate_required([:enabled])
  end
end

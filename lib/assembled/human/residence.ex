defmodule Assembled.Human.Residence do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "human_residences" do
    field :zip, :string
    field :address, {:array, :string}
    field :zone, :string
    field :region, :string
    field :nation, :string
    field :begins, :utc_datetime
    field :ends, :utc_datetime
    field :human_key, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(residence, attrs) do
    residence
    |> cast(attrs, [:address, :zone, :region, :nation, :zip, :begins, :ends])
    |> validate_required([:address, :zone, :region, :nation, :zip, :begins, :ends])
  end
end

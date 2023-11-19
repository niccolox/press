defmodule Assembled.Human.Channel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "human_channels" do
    field :mode, Ecto.Enum, values: [:email, :phone, :sms]
    field :address, :string
    field :human_key, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:mode, :address])
    |> validate_required([:mode, :address])
  end
end

defmodule Assembled.Repo.Migrations.CreateHumanChannels do
  use Ecto.Migration

  def change do
    create table(:human_channels, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :mode, :string
      add :address, :string
      add :human_key, references(:humans, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:human_channels, [:human_key])
  end
end

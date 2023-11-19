defmodule Assembled.Repo.Migrations.CreateHumans do
  use Ecto.Migration

  def change do
    create table(:humans, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :enabled, {:array, :utc_datetime}

      timestamps(type: :utc_datetime)
    end
  end
end

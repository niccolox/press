defmodule Assembled.Repo.Migrations.CreateHumanResidences do
  use Ecto.Migration

  def change do
    create table(:human_residences, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :address, {:array, :string}
      add :zone, :string
      add :region, :string
      add :nation, :string
      add :zip, :string
      add :begins, :utc_datetime
      add :ends, :utc_datetime
      add :human_key, references(:humans, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:human_residences, [:human_key])
  end
end

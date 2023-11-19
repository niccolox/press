defmodule Assembled.Repo.Migrations.CreateHumanAliases do
  use Ecto.Migration

  def change do
    create table(:human_aliases, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :legal_name, {:array, :string}
      add :human_key, references(:humans, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:human_aliases, [:human_key])
  end
end

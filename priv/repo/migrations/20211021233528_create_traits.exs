defmodule Snekinfo.Repo.Migrations.CreateTraits do
  use Ecto.Migration

  def change do
    create table(:traits) do
      add :name, :string, null: false
      add :inheritance, :string

      timestamps()
    end
  end
end
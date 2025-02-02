defmodule Snekinfo.TraitsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Snekinfo.Traits` context.
  """

  @doc """
  Generate a trait.
  """
  def trait_fixture(attrs \\ %{}) do
    sp = Snekinfo.TaxaFixtures.species_fixture()

    {:ok, trait} =
      attrs
      |> Enum.into(%{
        inheritance: "poly",
        name: "wings",
        species_id: sp.id,
      })
      |> Snekinfo.Traits.create_trait()

    trait
  end
end

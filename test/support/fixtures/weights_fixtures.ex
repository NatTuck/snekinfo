defmodule Snekinfo.WeightsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Snekinfo.Weights` context.
  """

  @doc """
  Generate a weight.
  """
  def weight_fixture(attrs \\ %{}) do
    {:ok, weight} =
      attrs
      |> Enum.into(%{
        timestamp: ~U[2021-10-20 23:42:00Z],
        weight: 120.5
      })
      |> Snekinfo.Weights.create_weight()

    weight
  end
end

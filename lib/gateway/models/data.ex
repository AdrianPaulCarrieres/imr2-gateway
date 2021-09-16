defmodule Gateway.Models.Data do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Data schema definition
  """

  @primary_key false

  schema "data" do
    field(:id, :string)
    field(:region, :string)
    field(:energy, :integer)
    field(:temperature, :integer)
    field(:salinity, :integer)
    field(:flow, :integer)
    field(:geohash, :string)

    field(:created_at, :naive_datetime)
  end

  @doc false
  def changeset(data, attrs) do
    data
    |> cast(attrs, [:id, :region, :energy, :temperature, :salinity, :flow, :geohash])
    |> validate_required([:id, :region, :energy, :temperature, :salinity, :flow, :geohash])
  end
end

defmodule Gateway.Models.Data do
  use Ecto.Schema
  import Ecto.Changeset

  @moduledoc """
  Data schema definition
  """

  @derive {Jason.Encoder, only: [:id, :region, :energy, :temperature, :salinity, :flow, :geohash, :created_at]}

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
    |> cast(attrs, [:id, :region, :energy, :temperature, :salinity, :flow, :geohash, :created_at])
    |> validate_required([:id, :region, :energy, :temperature, :salinity, :flow, :geohash])
  end
end

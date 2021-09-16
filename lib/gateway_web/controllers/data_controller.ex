defmodule GatewayWeb.DataController do
  use GatewayWeb, :controller

  alias Gateway.Models.Data

  action_fallback GatewayWeb.FallbackController

  def create(conn, %{"data" => data_params}) do
    with {:ok, %Data{} = data} <- create_data(data_params) do

      Gateway.Publisher.publish(data)

      send_resp(conn, :ok, "OK")
    end
  end

  defp create_data(attrs) do
    %Data{}
    |> Data.changeset(attrs)
    |> Ecto.Changeset.apply_action(:insert)
  end
end

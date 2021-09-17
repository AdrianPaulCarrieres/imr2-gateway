defmodule GatewayPipeline.SupervisorPublisher do
  use ConsumerSupervisor
  require Logger

  alias GatewayPipeline.StagePublisher

  def start_link(_args) do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    Logger.info("SupervisorPublisher init")

    children = [
      %{
        id: StagePublisher,
        start: {StagePublisher, :start_link, []},
        restart: :transient
      }
    ]

    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        {GatewayPipeline.StageQueue, min_demand: 0, max_demand: 1000}
      ]
    ]

    ConsumerSupervisor.init(children, opts)
  end
end

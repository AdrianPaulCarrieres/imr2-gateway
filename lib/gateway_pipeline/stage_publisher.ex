defmodule GatewayPipeline.StagePublisher do
  use GenStage
  require Logger

  @moduledoc """
  Will publish to RabbitMQ
  """

  def start_link(_args) do
    GenStage.start_link(__MODULE__, :nil)
  end

  def init(_) do
    Logger.debug("StagePublisher init")
    {:consumer, nil, subscribe_to: [GatewayPipeline.StageQueue]}
  end

  def handle_events(events, _from, state) do
    Logger.info("Publishing #{inspect(events)}")

    worker_pid = :poolboy.checkout(:pool_worker)

    events
    |> Enum.each(&GenServer.call(worker_pid, {:publish, &1}))

    {:noreply, [], state}
  end
end

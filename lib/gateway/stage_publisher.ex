defmodule Gateway.StagePublisher do
  use GenStage
  require Logger

  @moduledoc """
  Will publish to RabbitMQ
  """

  def start_link(_args) do
    GenStage.start_link(__MODULE__, :useless)
  end

  def init(_) do

    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, "imr2")

    Logger.debug("StagePublisher init")
    {:consumer, channel, subscribe_to: [Gateway.StageQueue]}
  end

  def handle_events(events, _from, channel) do
    Logger.info("Publishing #{inspect(events)}")

    events
    |> Enum.each(&AMQP.Basic.publish(channel, "", "imr2", &1))

    {:noreply, [], channel}
  end
end

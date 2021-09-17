defmodule Gateway.PoolWorker do
  require Logger
  use GenServer

  @moduledoc """
  Publish message to RabbitMQ
  """

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(_) do

    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)
    AMQP.Queue.declare(channel, "imr2")

    Logger.debug("Poolworker init")

    {:ok, channel}
  end

  def publish(element) do
    GenServer.call(__MODULE__, {:publish, element})
  end

  @impl true
  def handle_call({:publish, element}, _from, channel) do
    message = Jason.encode!(element)


    :ok = AMQP.Basic.publish(channel, "", "imr2", message)

    {:reply, :ok, channel}
  end
end

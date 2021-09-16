defmodule Gateway.Publisher do
  require Logger
  use GenServer

  @moduledoc """
  Publish message to RabbitMQ
  """

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, channel} = AMQP.Application.get_channel(:channel)

    AMQP.Queue.declare(channel, "publisher")

    Logger.info "lets go"

    {:ok, %{}}
  end

  def publish(element) do
    GenServer.cast(__MODULE__, {:publish, element})
    Logger.info("hi ?")
  end

  @impl true
  def handle_cast({:publish, element}, %{} = state) do
    Logger.info("handling cast aaaza")

    message = Jason.encode!(element)

    Logger.info("received message #{inspect(message)}")

    {:ok, channel} = AMQP.Application.get_channel(:channel)

    :ok = AMQP.Basic.publish(channel, "", "publisher", message)

    {:noreply, state}
  end
end

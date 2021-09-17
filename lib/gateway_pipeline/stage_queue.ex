defmodule GatewayPipeline.StageQueue do
  use GenStage
  require Logger

  @moduledoc """
  Stage getting events to distribute
  """

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    GenStage.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec push(any) :: :ok
  def push(element) do
    GenStage.cast(__MODULE__, {:element, element})
  end

  @impl true
  def init(_) do
    Logger.debug("StageQueue init")
    {:producer, []}
  end

  @impl true
  def handle_cast({:element, element}, state) do
    {:noreply, [element], state}
  end

  @impl true
  def handle_demand(demand, state) do

    events = []
    {:noreply, events, state}
  end
end

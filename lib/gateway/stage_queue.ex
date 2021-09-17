defmodule Gateway.StageQueue do
  use GenStage
  require Logger

  @moduledoc """
  Stage getting events to distribute
  """

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @spec push(any) :: :ok
  def push(element) do
    GenServer.cast(__MODULE__, {:push, element})
  end

  @impl true
  @spec init(any) :: {:producer, :queue.queue(any)}
  def init(_) do
    {:producer, :queue.new()}
  end

  @impl true
  @spec handle_cast({:push, any}, :queue.queue(any)) :: {:noreply, :queue.queue(any)}
  def handle_cast({:push, element}, queue) do
    queue = :queue.in(element, queue)

    {:noreply, queue}
  end

  @impl true
  def handle_demand(demand, queue) when demand > 0 do
    %{elements: elements, queue: queue} =
      Enum.reduce_while(1..demand, %{elements: [], queue: queue}, fn _count,
                                                                     %{
                                                                       elements: elements,
                                                                       queue: q
                                                                     } = acc ->
        case :queue.out(q) do
          {{:value, element}, q} ->
            elements = [element | elements]

            acc = %{acc | elements: elements, queue: q}
            {:continue, acc}

          {{:empty, q}} ->
            acc = %{acc | queue: q}
            {:halt, acc}
        end
      end)

    events = elements |> Enum.reverse()
    {:noreply, events, queue}
  end
end

defmodule GatewayPipeline.StagePublisher do
  require Logger

  @moduledoc """
  Will publish to RabbitMQ
  """

  def start_link(event) do
    Task.start_link(fn ->
      worker_pid = :poolboy.checkout(:pool_worker)

      GenServer.call(worker_pid, {:publish, event})

      :poolboy.checkin(:pool_worker, worker_pid)
    end)
  end
end

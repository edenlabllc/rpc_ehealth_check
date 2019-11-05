defmodule HealthCheck.Worker do
  @moduledoc false

  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def init(state) do
    Process.send_after(self(), :check, get_interval())
    {:ok, state}
  end

  @impl true
  def handle_info(:check, state) do
    nodes = Node.list()
    Logger.info("Cluster nodes: " <> Enum.join(nodes, ","))

    topologies = Application.get_env(:health_check, :topologies)

    nodes
    |> Enum.reduce([], fn server, acc ->
      basename =
        case String.split(to_string(server), "@") do
          [basename, _] -> basename
          _ -> server
        end

      send_check? =
        Enum.any?(topologies, fn {_, v} ->
          v |> Keyword.get(:config) |> Keyword.get(:kubernetes_node_basename) == basename
        end)

      if send_check? do
        acc ++ [{server, basename}]
      else
        acc
      end
    end)
    |> Enum.map(fn {server, basename} ->
      Task.async(fn -> send_health_check(server, basename) end)
    end)
    |> Enum.each(&Task.await/1)

    Process.send_after(self(), :check, get_interval())
    {:noreply, state}
  end

  defp get_ergonode(basename) do
    Enum.find(
      Application.get_env(:health_check, :ergonodes) || [],
      &(Map.get(&1, "basename") == basename)
    )
  end

  defp get_interval do
    case System.get_env("CHECK_INTERVAL") && Integer.parse(System.get_env("CHECK_INTERVAL")) do
      {value, _} -> value
      _ -> 2_000
    end
  end

  defp send_health_check(server, basename) do
    Logger.info("Send health check to #{server}")

    case get_ergonode(basename) do
      nil ->
        case :global.whereis_name(server) do
          :undefined ->
            nil

          pid ->
            GenServer.cast(pid, :check)
        end

      ergonode_config ->
        try do
          pid = GenServer.call({ergonode_config["process"], server}, ergonode_config["pid_message"], 500)
          :global.register_name(server, pid)
          GenServer.cast(pid, :check)
        catch
          :exit, _ -> Logger.warn("Failed to send edgonode check #{server}")
        end
    end
  end
end

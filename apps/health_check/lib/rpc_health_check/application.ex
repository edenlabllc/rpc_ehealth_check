defmodule HealthCheck.Application do
  @moduledoc false

  use Application
  alias HealthCheck.Worker

  def start(_type, _args) do
    children = [{Worker, []}]

    children =
      if Application.get_env(:health_check, :env) == :prod do
        children ++
          [
            {Cluster.Supervisor,
             [
               Application.get_env(:health_check, :topologies),
               [name: HealthCheck.ClusterSupervisor]
             ]}
          ]
      else
        children
      end

    opts = [strategy: :one_for_one, name: HealthCheck.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

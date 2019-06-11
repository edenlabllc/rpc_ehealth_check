use Mix.Config

config :health_check,
  env: Mix.env()

config :health_check,
  ergonodes: [
    %{"basename" => "me_transactions", "process" => :mongo_transaction, "pid_message" => :pid}
  ]

config :logger_json, :backend,
  formatter: EhealthLogger.Formatter,
  metadata: :all

config :logger,
  backends: [LoggerJSON],
  level: :info

config :health_check,
  topologies: [
    k8s_me_event_consumer: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_ip_lookup_mode: :pods,
        kubernetes_node_basename: "event_consumer",
        kubernetes_selector: "app=event-consumer",
        kubernetes_namespace: "me",
        polling_interval: 10_000
      ]
    ],
    k8s_me_transactions: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_ip_lookup_mode: :pods,
        kubernetes_node_basename: "me_transactions",
        kubernetes_selector: "app=me-transactions",
        kubernetes_namespace: "me",
        polling_interval: 10_000
      ]
    ],
    k8s_edr_api: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_ip_lookup_mode: :pods,
        kubernetes_node_basename: "edr_api",
        kubernetes_selector: "app=edr-api",
        kubernetes_namespace: "edr",
        polling_interval: 10_000
      ]
    ],
    k8s_jabba: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "jabba-rpc",
        kubernetes_selector: "app=jabba-rpc",
        kubernetes_namespace: "jabba",
        polling_interval: 10_000
      ]
    ]
  ]

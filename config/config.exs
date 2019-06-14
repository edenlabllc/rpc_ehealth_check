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
    k8s_ael_api: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "ael_api",
        kubernetes_selector: "app=api",
        kubernetes_namespace: "ael",
        polling_interval: 10_000
      ]
    ],
    k8s_ds_api: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "ds_api",
        kubernetes_selector: "app=ds-api",
        kubernetes_namespace: "digital-signature",
        polling_interval: 10_000
      ]
    ],
    k8s_ds_synchronizer: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_ip_lookup_mode: :pods,
        kubernetes_node_basename: "synchronizer_crl",
        kubernetes_selector: "app=synchronizer-crl",
        kubernetes_namespace: "digital-signature",
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
    k8s_ehealth_api: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "ehealth",
        kubernetes_selector: "app=api",
        kubernetes_namespace: "il",
        polling_interval: 10_000
      ]
    ],
    k8s_casher: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "casher",
        kubernetes_selector: "app=casher",
        kubernetes_namespace: "il",
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
    ],
    k8s_me: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "medical_events_api",
        kubernetes_selector: "app=api-medical-events",
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
    k8s_number_generator: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "number_generator",
        kubernetes_selector: "app=number-generator",
        kubernetes_namespace: "me",
        polling_interval: 10_000
      ]
    ],
    k8s_mithril: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "mithril_api",
        kubernetes_selector: "app=api",
        kubernetes_namespace: "mithril",
        polling_interval: 10_000
      ]
    ],
    k8s_mpi_api: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "mpi",
        kubernetes_selector: "app=api",
        kubernetes_namespace: "mpi",
        polling_interval: 10_000
      ]
    ],
    k8s_manual_merger: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "manual_merger",
        kubernetes_selector: "app=manual-merger",
        kubernetes_namespace: "mpi",
        polling_interval: 10_000
      ]
    ],
    k8s_ops: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "ops",
        kubernetes_selector: "app=api",
        kubernetes_namespace: "ops",
        polling_interval: 10_000
      ]
    ],
    k8s_report_cache: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "report_cache",
        kubernetes_selector: "app=cache",
        kubernetes_namespace: "reports",
        polling_interval: 10_000
      ]
    ],
    k8s_uaddresses: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "uaddresses_api",
        kubernetes_selector: "app=api",
        kubernetes_namespace: "uaddresses",
        polling_interval: 10_000
      ]
    ],
    k8s_otp_verification: [
      strategy: Elixir.Cluster.Strategy.Kubernetes,
      config: [
        mode: :dns,
        kubernetes_node_basename: "otp_verification_api",
        kubernetes_selector: "app=api",
        kubernetes_namespace: "verification",
        polling_interval: 10_000
      ]
    ]
  ]

config :git_ops,
  mix_project: RpcHealthCheck.MixProject,
  changelog_file: "CHANGELOG.md",
  repository_url: "https://github.com/edenlabllc/rpc_health_check",
  types: [
    # Makes an allowed commit type called `tidbit` that is not
    # shown in the changelog
    tidbit: [
      hidden?: true
    ],
    # Makes an allowed commit type called `important` that gets
    # a section in the changelog with the header "Important Changes"
    important: [
      header: "Important Changes"
    ]
  ],
  # Instructs the tool to manage your mix version in your `mix.exs` file
  # See below for more information
  manage_mix_version?: true,
  # Instructs the tool to manage the version in your README.md
  # Pass in `true` to use `"README.md"` or a string to customize
  manage_readme_version: "README.md"

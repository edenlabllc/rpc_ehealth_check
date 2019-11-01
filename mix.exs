defmodule RpcHealthCheck.MixProject do
  @moduledoc false

  use Mix.Project

  @version "0.2.0"

  def project do
    [
      version: @version,
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        rpc_health_check: [
          include_executables_for: [:unix],
          applications: [runtime_tools: :permanent, health_check: :permanent]
        ]
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test]}
    ]
  end
end

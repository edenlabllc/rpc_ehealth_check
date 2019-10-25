defmodule HealthCheck.MixProject do
  use Mix.Project

  def project do
    [
      app: :health_check,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HealthCheck.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ehealth_logger, git: "https://github.com/edenlabllc/ehealth_logger.git"},
      {:libcluster, "~> 3.1"},
      {:git_ops, "~> 0.6.0", only: [:dev]}
    ]
  end
end

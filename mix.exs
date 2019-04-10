defmodule ExAws.RDS.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_aws_rds,
      version: "2.0.3",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: "ExAws.RDS service package",
      source_url: "https://github.com/ex-aws/ex_aws_rds",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:hackney, ">= 0.0.0", only: [:dev, :test]},
      {:sweet_xml, ">= 0.0.0", only: [:dev, :test]},
      {:poison, ">= 0.0.0", only: [:dev, :test]},
      {:ex_doc, "~> 0.19", only: [:dev, :test]},
      ex_aws()
    ]
  end

  defp ex_aws() do
    case System.get_env("AWS") do
      "LOCAL" -> {:ex_aws, path: "../ex_aws"}
      _ -> {:ex_aws, "~> 2.0"}
    end
  end

  defp package do
    [
      maintainers: ["Ben Wilson", "Kyle Anderson"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/ex-aws/ex_aws_rds"}
    ]
  end
end

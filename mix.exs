defmodule ElasticlunrS3Storage.MixProject do
  use Mix.Project

  @source_url "https://github.com/heywhy/ex_elasticlunr_s3"

  def project do
    [
      app: :elasticlunr_s3,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:elasticlunr, "~> 0.6", only: [:dev, :test]},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.25", only: :dev, runtime: false},
      {:mox, "~> 1.0", only: :test}
    ]
  end

  defp aliases do
    [
      test: ~w[format credo test]
    ]
  end

  defp description do
    "Elasticlunr S3 provides a storage interface for AWS S3."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Atanda Rasheed"],
      licenses: ["MIT License"],
      links: %{
        "GitHub" => @source_url,
        "Docs" => "https://hexdocs.pm/elasticlunr_s3"
      }
    ]
  end
end

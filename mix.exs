defmodule ExKaggle.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_kaggle,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      source_url: "https://github.com/byronalley/ex_kaggle",
      homepage_url: "https://github.com/byronalley/ex_kaggle",
      docs: &docs/0
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.4"},
      {:mox, "~> 1.1", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:mix_test_interactive, "~> 4.3", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A library to connect with the Kaggle API"
  end

  defp package do
    [
      files: ~w(lib priv .formatter.exs mix.exs README* LICENSE*
        CHANGELOG* src),
      licenses: ["BSD 3-Clause"],
      links: %{"GitHub" => "https://github.com/byronalley/ex_kaggle"}
    ]
  end

  defp docs do
    [
      main: "ExKaggle",
      extras: ["README.md"]
    ]
  end
end

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
      {:mox, "~> 1.1", only: :test}
    ]
  end

  defp description do
    "A library to connect with the Kaggle API"
  end

  defp package do
    [
      files: ~w(lib test README* ),
      licenses: ["BSD 3-Clause"]
    ]
  end

  defp docs do
    [
      main: "ExKaggle",
      extras: ["README.md"]
    ]
  end
end

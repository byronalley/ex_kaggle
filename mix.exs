defmodule ExKaggle.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_kaggle,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
end

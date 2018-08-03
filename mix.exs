defmodule Pubsub.MixProject do
  use Mix.Project

  def project do
    [
      app: :pubsub,
      version: "0.1.0",
      elixir: "~> 1.7-rc",
      start_permanent: Mix.env() == :prod,
      deps: []
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Pubsub.Application, []}
    ]
  end

end

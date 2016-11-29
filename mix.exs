defmodule Piper.Mixfile do
  use Mix.Project

  @name :piper
  @version "0.0.3"
  @description """
  Simple task router similar to Phoenix.Router and Plug
  """

  def project do
    [app: @name,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     description: @description,
     deps: deps(),
     docs: [main: "readme",
            extras: ["README.md"]]]
  end

  def package do
    [name: @name,
     files: ["lib", "mix.exs", "README*", "LICENSE*"],
     maintainers: ["AppUnite", "Łukasz Niemier", "Rafał Radziszewski"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/appunite/piper",
              "Docs" => "https://hexdocs.pm/piper"}]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger], mod: {Piper, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
     [{:ex_doc,           ">= 0.0.0",  only: :dev},
      {:credo,            "~> 0.4",    only: :dev},
      {:mix_test_watch,   "~> 0.2",    only: :dev},
      {:ex_unit_notifier, "~> 0.1",    only: [:dev, :test]}]
  end
end

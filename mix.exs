defmodule Okasaki.Mixfile do
  use Mix.Project

  def project do
    [app: :okasaki,
     version: "1.0.0",
     elixir: "~> 1.3",
     name: "Okasaki",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     description: description(),
     source_url: "https://github.com/Qqwy/elixir_okasaki",
     package: package()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: :dev},

      {:insertable, "~> 0.2.0"},
      {:extractable, "~> 1.0.0"},
      {:fun_land, "~> 0.10.0"},
    ]
  end

  defp description do
    """
    Well-structured Queues for Elixir, offering a common interface with multiple implementations with varying performance guarantees that can be switched in your configuration.
    """
  end

  defp package() do
    [
      name: :okasaki,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Qqwy/Wiebe-Marten Wijnja"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/Qqwy/elixir_okasaki"}
    ]
  end


end

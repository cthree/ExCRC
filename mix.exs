defmodule ExCRC.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_crc,
      version: "0.1.0",
      elixir: "~> 1.5",
      description: description(),
      package: package(),
      docs: [extras: ["README.md"]],
      aliases: ["docs": ["docs", &copy_images/1]],
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps(),
      name: "ExCRC",
      source_url: "https://github.com/cthree/ex_crc"
    ]
  end

  def application, do: []

  defp elixirc_paths(:prod), do: ["lib"]
  defp elixirc_paths(_), do: ["test/support", "lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.14", only: [:dev]}
    ]
  end

  defp description do
    """
    Pure Elixir implementation of CCITT CRC16 algorithm.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Erik Petersen"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/cthree/ex_crc"}
    ]
  end

  defp copy_images(_) do
    File.cp_r "assets", "doc/assets"
  end
end

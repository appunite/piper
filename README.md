# Piper

Plug-like data processing library.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `piper` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:piper, "~> 0.1.0"}]
    end
    ```

  2. Ensure `piper` is started before your application:

    ```elixir
    def application do
      [applications: [:piper]]
    end
    ```

## Usage

Piper pipeline can be built using either functions or modules. This way you can
provide deencapsulation and processing data in pipeline-like way. Example:

```elixir
defmodule FetchFromRepoPipe do
  alias MyApp.Repo

  def init(opts), do: opts

  def call(%Piper.Data{data: %{"id" => id}}, _opts) do
    data
    |> assign(:user, Repo.get(User, id))
  end
end

defmodule UpdatePassword do
  use Piper.Builder

  alias MyApp.Repo

  pipe FetchFromRepoPipe
  pipe :encrypt, module: Comeoin.Bcrypt
  pipe :set
  pipe :save

  def encrypt(%{data: %{"password" => password}} = data, [module: module]) do
    data
    |> assign(:password, module.hashpw(password))
  end

  def set(%{assigns: %{user: user, password: password}} = data, _opts) do
    data
    |> assign(:user, %{user | password: password})
  end

  def save(%{assigns: %{user: user}} = data, _opts) do
    data
    |> assign(:user, Repo.update(user))
  end
end
```

## Special thanks

- Jose Valim ([@josevalim](https://github.com/josevalim))
- Andrea Leopardi ([@whatyouhide](https://github.com/whatyouhide))
- Sonny Scroggin ([@scrogson](https://github.com/scrogson))
- Gabriel Jaldon ([@gjaldon](https://github.com/gjaldon))
- and other contributors to [elixir-lang/plug](https://github.com/elixir-lang/plug)
  for your work on Plug which allowed us to create this library.

defmodule Piper.Pipe.Log do
  @behaviour Piper

  @moduledoc """
  Pipe that will log `Piper.Data` passed to the `Piper.call\2`.

  ## Options

  - `level` - debug level, defaults to `:debug`
  """

  require Logger

  def init(opts), do: opts

  def call(data, opts) do
    level = opts[:level] || :debug

    apply(Logger, level, [inspect(data)])
  end
end

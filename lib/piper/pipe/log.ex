defmodule Piper.Pipe.Log do
  @behaviour Piper

  require Logger

  def init(opts), do: opts

  def call(data, opts) do
    level = opts[:level] || :debug

    apply(Logger, level, [inspect(data)])
  end
end

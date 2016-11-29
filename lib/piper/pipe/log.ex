defmodule Piper.Pipe.Log do
  @behaviour Piper

  @moduledoc """
  Pipe that will log `Piper.Data` passed to the `Piper.call\2`.

  ## Options

  - `level` - method to be called on `logger` module, defaults to `:debug`
  """

  require Logger

  def init(opts) do
    Keyword.merge([level: :debug, func: &inspect/1], opts)
  end

  def call(data, [level: level, func: f]) do
    :ok = Logger.log(level, f.(data))

    data
  end
end

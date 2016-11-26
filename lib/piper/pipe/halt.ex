defmodule Piper.Pipe.Halt do
  @behaviour Piper

  def init(opts), do: opts

  def call(data, _opts), do: Piper.Data.halt(data)
end

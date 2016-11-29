defmodule Piper.Pipe.Halt do
  @behaviour Piper

  @moduledoc """
  Pipe that will halt execution of any pipeline.
  """

  def init(opts), do: opts

  def call(data, _opts), do: Piper.Data.halt(data)
end

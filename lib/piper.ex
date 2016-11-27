defmodule Piper do
  @type opts :: tuple | atom | integer | float | [opts]

  require Piper.Data

  use Behaviour
  use Application

  @moduledoc """
  The pipeline specification.

  ### Function pipes

  Pipe can be any fuction that receives data and set of options and returns
  data. It's type signature must be:

      (Piper.Data.t, Piper.opts) :: Piper.Data.t

  ### Module pipes

  A module pipe is extension of fuction pipe. It is module that must export:

  - a `call\2` function with signature defined above
  - an `init\1` which takes a set of options and initializes it.

  The result returned by `init/1` is passed as second argument to `call/2`. Note
  that `init/1` may be called during compilation and as such it must not return
  pids, ports or values that are not specific to the runtime.

  The API expected by a module plug is defined as a behaviour by the `Piper`
  module (this module).
  """

  defcallback init(opts) :: opts
  defcallback call(Piper.Data.t, opts) :: Piper.Data.t

  @doc false
  def start(_type, _args) do
    Piper.Supervisor.start_link()
  end
end

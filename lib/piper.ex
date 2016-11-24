defmodule Piper do
  @type opts :: tuple | atom | integer | float | [opts]

  require Piper.Data

  use Behaviour
  use Application

  defcallback init(opts) :: opts
  defcallback call(Piper.Data.t, opts) :: Piper.Data.t

  def start(_type, _args) do
    Piper.Supervisor.start_link()
  end
end

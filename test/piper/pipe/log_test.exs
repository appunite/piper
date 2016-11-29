defmodule Piper.Pipe.LogTest do
  use ExUnit.Case
  doctest Piper.Pipe.Log

  import ExUnit.CaptureLog

  test "defult log level is `:debug`" do
    opts = Piper.Pipe.Log.init([])

    assert opts[:level] == :debug
  end

  test "we can change log level" do
    opts = Piper.Pipe.Log.init(level: :error)

    assert opts[:level] == :error
  end

  test "logged message is inspected value of `data`" do
    opts = Piper.Pipe.Log.init([])
    data = %Piper.Data{}

    log = capture_log(fn -> Piper.Pipe.Log.call(data, opts) end)

    assert log =~ inspect(data)
  end
end

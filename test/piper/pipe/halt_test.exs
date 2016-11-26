defmodule Piper.Pipe.HaltTest do
  use ExUnit.Case
  doctest Piper.Pipe.Halt

  test "set halt flag to true" do
    data = %Piper.Data{halted: false}
           |> Piper.Pipe.Halt.call([])

    assert data.halted
  end
end

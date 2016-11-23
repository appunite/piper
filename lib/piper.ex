defmodule Piper do
  @moduledoc """
  Pipes router module
  """

  defmacro __using__(_) do
    quote do
      import Piper

      Module.register_attribute(__MODULE__, :pipelines, accumulate: true)

      def call(key, data) do
        pipelines = Module.get_attribute(__MODULE__, :pipelines)
        pipeline = Enum.find_value(pipelines, [], fn ({k, list}) ->
          if k == key do
            list
          end
        end)
        Enum.reduce(pipeline, data, fn({module, _opts}, acc) ->
          {:ok, data} = apply(module, :call, [acc])
          data
        end)
      end
    end
  end

  @doc """
  Create new pipeline
  """
  defmacro pipeline(name, [do: block]) do
    quote do
      @pipeline_pipes []
      unquote(block)
      Module.put_attribute(__MODULE__, :pipelines, {unquote(name), @pipeline_pipes})
      @pipeline_pipes nil
    end
  end

  @doc """
  Add new processor to pipeline
  """
  defmacro pipe(module, opts \\ []) do
    quote do
      if pip = @pipeline_pipes do
        @pipeline_pipes [{unquote(module), unquote(opts)} | pip]
      else
        raise "Cannot introduce pipe outside pipeline"
      end
    end
  end
end

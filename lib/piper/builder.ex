defmodule Piper.Builder do
  @type pipe :: module | atom

  @moduledoc """
  Builder for Piper pipeline
  """

  defmacro __using__(opts) do
    quote do
      @behaviour Piper
      @pipe_builder_opts unquote(opts)

      def init(opts) do
        opts
      end

      def call(data, opts) do
        pipe_builder_call(data, opts)
      end

      defoverridable [init: 1, call: 2]

      import Piper.Data
      import Piper.Builder, only: [pipe: 1, pipe: 2]

      Module.register_attribute(__MODULE__, :pipes, accumulate: true)
      @before_compile Piper.Builder
    end
  end

  defmacro __before_compile__(env) do
    pipes        = Module.get_attribute(env.module, :pipes)
    builder_opts = Module.get_attribute(env.module, :pipe_builder_opts)

    {data, body} = Piper.Builder.compile(env, pipes, builder_opts)

    quote do
      defp pipe_builder_call(unquote(data), _), do: unquote(body)
    end
  end

  @doc """
  A macro that stores a new pipe. `opts` will be passed unchanged to the new
  pipe.
  """
  defmacro pipe(pipe, opts \\ []) do
    quote do
      @pipes {unquote(pipe), unquote(opts), true}
    end
  end

  @doc false
  @spec compile(Macro.Env.t, [{pipe, Piper.opts, Macro.t}], Keyword.t) :: {Macro.t, Macro.t}
  def compile(env, pipeline, builder_opts) do
    data = quote do: data
    {data, Enum.reduce(pipeline, data, &quote_pipe(init_pipe(&1), &2, env, builder_opts))}
  end

  defp init_pipe({pipe, opts, guards}) do
    case Atom.to_char_list(pipe) do
      'Elixir.' ++ _ -> init_module_pipe(pipe, opts, guards)
      _              -> init_fun_pipe(pipe, opts, guards)
    end
  end

  defp init_module_pipe(pipe, opts, guards) do
    initialized_opts = pipe.init(opts)

    if function_exported?(pipe, :call, 2) do
      {:module, pipe, initialized_opts, guards}
    else
      raise ArgumentError, message: "#{inspect pipe} pipe must implement call/2"
    end
  end

  defp init_fun_pipe(pipe, opts, guards) do
    {:function, pipe, opts, guards}
  end

  defp quote_pipe({pipe_type, pipe, opts, guards}, acc, env, builder_opts) do
    call = quote_pipe_call(pipe_type, pipe, opts)

    error_message = case pipe_type do
      :module   -> "expected #{inspect pipe}.call/2 to return a Piper.Data"
      :function -> "expected #{pipe}/2 to return a Piper.Data"
    end <> ", all pipe must receive data and return data"

    quote do
      case unquote(compile_guards(call, guards)) do
        %Piper.Data{halted: true} = data ->
          unquote(log_halt(pipe_type, pipe, env, builder_opts))
          data
        %Piper.Data{} = data ->
          unquote(acc)
        _ ->
          raise unquote(error_message)
      end
    end
  end

  defp quote_pipe_call(:function, pipe, opts) do
    quote do: unquote(pipe)(data, unquote(Macro.escape(opts)))
  end

  defp quote_pipe_call(:module, pipe, opts) do
    quote do: unquote(pipe).call(data, unquote(Macro.escape(opts)))
  end

  defp compile_guards(call, true) do
    call
  end

  defp compile_guards(call, guards) do
    quote do
      case true do
        true when unquote(guards) -> unquote(call)
        true -> data
      end
    end
  end

  defp log_halt(pipe_type, pipe, env, builder_opts) do
    if level = builder_opts[:log_on_halt] do
      message = case pipe_type do
        :module   -> "#{inspect env.module} halted in #{inspect pipe}.call/2"
        :function -> "#{inspect env.module} halted in #{inspect pipe}/2"
      end

      quote do
        require Logger
        Logger.unquote(level)(unquote(message))
      end
    else
      nil
    end
  end
end

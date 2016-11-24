defmodule Piper.Data do
  @type t :: %__MODULE__{}

  alias Piper.Data

  defstruct assigns: %{},
            data: %{},
            halted: false

  def assign(%Data{assigns: assigns} = data, key, value) do
    %{data | assigns: Map.put(assigns, key, value)}
  end

  def halt(%Data{} = data) do
    %{data | halted: true}
  end
end

defimpl Collectable, for: Piper.Data do
  def into(data) do
    {data, fn data, _ ->
      data
    end}
  end
end

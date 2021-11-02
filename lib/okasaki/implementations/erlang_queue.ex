defmodule Okasaki.Implementations.ErlangQueue do
  alias __MODULE__

  @moduledoc """
  A queue implementation wrapping the built-in `:queue` module.
  """
  @enforce_keys :contents
  defstruct [:contents]

  @opaque t :: %__MODULE__{
    contents: {list, list}
  }

  if Code.ensure_loaded?(FunLand.Mappable) do
    @behaviour FunLand.Mappable
  end
  @spec map(t, (any -> any)) :: t
  def map(queue = %__MODULE__{contents: contents}, fun) do
    changes = :lists.map(fun, :queue.to_list(contents))
    %__MODULE__{queue | contents: :queue.from_list(changes)}
  end

  def empty(_opts \\ []) do
    %ErlangQueue{contents: :queue.new()}
  end

  def insert(queue = %ErlangQueue{contents: contents}, item) do
    new_contents = :queue.snoc(contents, item)
    %ErlangQueue{queue | contents: new_contents}
  end
  def remove(queue = %ErlangQueue{contents: contents}) do
    case :queue.out(contents) do
      {:empty, _} -> {:error, :empty}
      {{:value, item}, new_contents} ->
        new_queue = %ErlangQueue{queue | contents: new_contents}
        {:ok, {item, new_queue}}
    end
  end

  def member?(%ErlangQueue{contents: contents}, item), do: :queue.member(item, contents)

  def to_list(%ErlangQueue{contents: contents}), do: :queue.to_list(contents)

  def size(%ErlangQueue{contents: contents}), do: :queue.len(contents)

  defimpl Okasaki.Protocols.Queue do
    def insert(queue, item), do: @for.insert(queue, item)
    def remove(queue), do: @for.remove(queue)
    def to_list(%@for{contents: contents}), do: :queue.to_list(contents)
    def member?(%@for{contents: contents}, item), do: :queue.member(item, contents)
    def size(%@for{contents: contents}), do: :queue.len(contents)
    def empty?(%@for{contents: contents}), do: :queue.is_empty(contents)
  end
end

defmodule Okasaki.Implementations.ErlangDeque do
  alias __MODULE__

  @moduledoc """
  A deque implementation wrapping the built-in `:queue` module.
  """
  @enforce_keys :contents
  defstruct [:contents]

  @opaque t :: %__MODULE__{
    contents: {list, list}
  }

  # Note that the notions of 'right' and 'left'
  # are the opposite of what `:queue` considers them.

  use FunLand.Mappable
  @spec map(t, (any -> any)) :: t
  def map(deque = %__MODULE__{contents: contents}, fun) do
    changes = :lists.map(fun, :queue.to_list(contents))
    %__MODULE__{deque | contents: :queue.from_list(changes)}
  end

  def empty(_opts \\ []) do
    %ErlangDeque{contents: :queue.new()}
  end

  def insert_right(deque = %ErlangDeque{contents: contents}, item) do
    new_contents = :queue.snoc(contents, item)
    %ErlangDeque{deque | contents: new_contents}
  end

  def insert_left(deque = %ErlangDeque{contents: contents}, item) do
    new_contents = :queue.cons(item, contents)
    %ErlangDeque{deque | contents: new_contents}
  end

  def remove_right(deque = %ErlangDeque{contents: contents}) do
    case :queue.out_r(contents) do
      {:empty, _} -> {:error, :empty}
      {{:value, item}, new_contents} ->
        new_deque = %ErlangDeque{deque | contents: new_contents}
        {:ok, {item, new_deque}}
    end
  end

  def remove_left(deque = %ErlangDeque{contents: contents}) do
    case :queue.out(contents) do
      {:empty, _} -> {:error, :empty}
      {{:value, item}, new_contents} ->
        new_deque = %ErlangDeque{deque | contents: new_contents}
        {:ok, {item, new_deque}}
    end
  end

  def member?(%ErlangDeque{contents: contents}, item), do: :queue.member(item, contents)

  def to_list(%ErlangDeque{contents: contents}), do: :queue.to_list(contents)

  def size(%ErlangDeque{contents: contents}), do: :queue.len(contents)

  defimpl Okasaki.Protocols.Queue do
    def insert(deque, item), do: @for.insert_right(deque, item)
    def remove(deque), do: @for.remove_left(deque)
    def to_list(%@for{contents: contents}), do: :queue.to_list(contents)
    def member?(%@for{contents: contents}, item), do: :queue.member(item, contents)
    def size(%@for{contents: contents}), do: :queue.len(contents)
    def empty?(%@for{contents: contents}), do: :queue.is_empty(contents)
  end

  defimpl Okasaki.Protocols.Deque do
    def insert_left(deque, item), do: @for.insert_left(deque, item)
    def remove_left(deque), do: @for.remove_left(deque)
    def insert_right(deque, item), do: @for.insert_right(deque, item)
    def remove_right(deque), do: @for.remove_right(deque)
    def to_list(%@for{contents: contents}), do: :queue.to_list(contents)
    def member?(%@for{contents: contents}, item), do: :queue.member(item, contents)
    def size(%@for{contents: contents}), do: :queue.len(contents)
    def empty?(%@for{contents: contents}), do: :queue.is_empty(contents)
  end
end

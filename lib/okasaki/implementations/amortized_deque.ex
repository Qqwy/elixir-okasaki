defmodule Okasaki.Implementations.AmortizedDeque do
  @moduledoc """
  The standard implementation of a deque as a pair of lists.

  This implementation is somewhat simpler than the guaranteed constant-time implementation in `Queue`,
  but any particular `remove` might take O(n).
  """

  defstruct [left: [], right: [], size: 0]

  @opaque t :: %__MODULE__{
    size: integer,
    left: list,
    right: list
  }

  @spec new() :: t
  def new do
    %__MODULE__{}
  end

  @spec size(t) :: non_neg_integer
  def size(%__MODULE__{size: size}) do
    size
  end

  def to_list(%__MODULE__{left: left, right: right}) do
    left ++ :lists.reverse(right)
  end

  @spec insert_right(t, any) :: t
  def insert_right(adeque, item) do
    %__MODULE__{left: adeque.left, right: [item | adeque.right], size: adeque.size + 1}
  end

  @spec insert_left(t, any) :: t
  def insert_left(adeque, item) do
    %__MODULE__{left: [item | adeque.left], right: adeque.right, size: adeque.size + 1}
  end

  @spec remove_left(t) :: {:ok, {any, t}} | {:error, :empty}
  def remove_left(adeque = %__MODULE__{left: [], right: right}) do
    case right do
      [] -> {:error, :empty}
      _ ->
        [item | new_left] = :lists.reverse(right)
        new_adeque = %__MODULE__{left: new_left, right: [], size: adeque.size - 1}
        {:ok, {item, new_adeque}}
    end
  end

  def remove_left(_adeque = %__MODULE__{left: left, right: right, size: size}) do
    [item | left_rest] = left
    result = {item, %__MODULE__{left: left_rest, right: right, size: size - 1}}
    {:ok, result}
  end

  @spec remove_right(t) :: {:ok, {any, t}} | {:error, :empty}
  def remove_right(adeque = %__MODULE__{left: left, right: []}) do
    case left do
      [] -> {:error, :empty}
      _ ->
        [item | new_right] = :lists.reverse(left)
        new_adeque = %__MODULE__{left: [], right: new_right, size: adeque.size - 1}
        {:ok, {item, new_adeque}}
    end
  end

  def remove_right(_adeque = %__MODULE__{left: left, right: right, size: size}) do
    [item | right_rest] = right
    result = {item, %__MODULE__{left: left, right: right_rest, size: size - 1}}
    {:ok, result}
  end

  def member?(adeque, item) do
    item in adeque.left or item in adeque.right
  end

  defimpl Okasaki.Protocols.Queue do
    def insert(queue, item), do: @for.insert_right(queue, item)
    def remove(queue), do: @for.remove_left(queue)
    def to_list(queue), do: @for.to_list(queue)
    def member?(queue, item), do: @for.member?(queue, item)
    def size(queue), do: @for.size(queue)
  end

  defimpl Okasaki.Protocols.Deque do
    def insert_left(deque, item), do: @for.insert_left(deque, item)
    def remove_left(deque), do: @for.remove_left(deque)
    def insert_right(deque, item), do: @for.insert_right(deque, item)
    def remove_right(deque), do: @for.remove_right(deque)
    def to_list(deque), do: @for.to_list(deque)
    def member?(queue, item), do: @for.member?(queue, item)
    def size(queue), do: @for.size(queue)
  end
end

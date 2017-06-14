defmodule Okasaki.AmortizedQueue do
  @moduledoc """
  The standard implementation of a queue as a pair of lists.

  This implementation is somewhat simpler than the guaranteed constant-time implementation in `Queue`,
  but any particular `remove` might take O(n).
  """

  defstruct [:left, :right, :size]

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

  @spec insert(t, any) :: t
  def insert(aqueue, item) do
    %__MODULE__{left: aqueue.left, right: [item | aqueue.right], size: aqueue.size + 1}
  end

  @spec remove(t) :: {:ok, {any, t}} | {:error, :empty}
  def remove(aqueue = %__MODULE__{left: [], right: right}, item) do
    case right do
      [] -> {:error, :empty}
      _ ->
        [item | new_left] = :lists.reverse(right)
        new_aqueue = %__MODULE__{left: new_left, right: [], size: aqueue.size - 1}
        {:ok, {item, new_aqueue}}
    end
  end

  def remove(_aqueue = %__MODULE__{left: left, right: right, size: size}) do
    [item | left_rest] = left
    result = {item, %__MODULE__{left: left_rest, right: right, size: size - 1}}
    {:ok, result}
  end
end

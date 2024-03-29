defmodule Okasaki.Implementations.AmortizedQueue do
  @moduledoc """
  The standard implementation of a queue as a pair of lists.

  This implementation is somewhat simpler than the guaranteed constant-time implementation in `Queue`,
  but any particular `remove` might take O(n).
  """

  defstruct [left: [], right: [], size: 0]

  @opaque t :: %__MODULE__{
    size: integer,
    left: list,
    right: list
  }

  if Code.ensure_loaded?(FunLand.Mappable) do
    @behaviour FunLand.Mappable
  end
  @spec map(t, (any -> any)) :: t
  def map(queue = %__MODULE__{left: left, right: right}, fun) do
    %__MODULE__{queue | left: :lists.map(fun, left), right: :lists.map(fun, right)}
  end

  @spec empty(opts :: keyword) :: t
  def empty(_opts \\ []) do
    %__MODULE__{}
  end

  @spec size(t) :: non_neg_integer
  def size(%__MODULE__{size: size}) do
    size
  end

  @spec empty?(t) :: boolean
  def empty?(%__MODULE__{left: [], right: []}), do: true
  def empty?(%__MODULE__{}), do: false

  def to_list(%__MODULE__{left: left, right: right}) do
    left ++ :lists.reverse(right)
  end

  @spec insert(t, any) :: t
  def insert(aqueue, item) do
    %__MODULE__{left: aqueue.left, right: [item | aqueue.right], size: aqueue.size + 1}
  end

  @spec remove(t) :: {:ok, {any, t}} | {:error, :empty}
  def remove(aqueue = %__MODULE__{left: [], right: right}) do
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

  def member?(queue, item) do
    item in queue.left or item in queue.right
  end

  defimpl Okasaki.Protocols.Queue do
    def insert(queue, item), do: @for.insert(queue, item)
    def remove(queue), do: @for.remove(queue)
    def to_list(queue), do: @for.to_list(queue)
    def member?(queue, item), do: @for.member?(queue, item)
    def size(queue), do: @for.size(queue)
    def empty?(queue), do: @for.empty?(queue)
  end
end

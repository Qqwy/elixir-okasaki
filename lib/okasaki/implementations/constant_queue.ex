defmodule Okasaki.Implementations.ConstantQueue do
  @moduledoc """
  Okasaki.ConstantQueue
  is a Purely Functional Queue that performs both insertion and removal at guaranteed O(1) (constant) time.
  """

  defstruct left: [], right: [], lefthat: [], size: 0


  @opaque t :: %__MODULE__{
    size: integer,
    left: list,
    right: list,
    lefthat: list
  }

  @spec new() :: t
  def new do
    %__MODULE__{}
  end

  @spec size(t) :: non_neg_integer
  def size(%__MODULE__{size: size}) do
    size
  end

  @spec to_list(t) :: list
  def to_list(%__MODULE__{left: left, right: right}) do
    left ++ :lists.reverse(right)
  end

  @spec insert(t, any) :: t
  def insert(queue, item) do
    make_queue(queue.left, [item | queue.right], queue.lefthat, queue.size + 1)
  end

  @spec remove(t) :: {:ok, {any, t}} | {:error, :empty}
  def remove(queue) do
    case queue.left do
      [] ->
        {:error, :empty}
      [item | left_tail] ->
        result = {item, make_queue(left_tail, queue.right, queue.lefthat, queue.size - 1)}
        {:ok, result}
    end
  end

  def member?(queue, item) do
    item in queue.left or item in queue.right
  end

  defp make_queue(left, right, lefthat = [], size) do
    leftprime = rot(left, right, [])
    %__MODULE__{left: leftprime, right: [], lefthat: leftprime, size: size}
  end

  defp make_queue(left, right, lefthat, size) do
    %__MODULE__{left: left, right: right, lefthat: tl(lefthat), size: size}
  end

  defp rot(_left = [], right, accum) do
    [hd(right) | accum]
  end

  defp rot(left, right, accum) do
    [rhead | rtail] = right
    [hd(left) | rot(tl(left), rtail, [rhead | accum])]
  end

  defimpl Okasaki.Protocols.Queue do
    def new(), do: @for.new()
    def insert(queue, item), do: @for.insert(queue, item)
    def remove(queue), do: @for.remove(queue)
    def to_list(queue), do: @for.to_list(queue)
    def member?(queue, item), do: @for.member?(queue, item)
    def size(queue), do: @for.size(queue)
  end
end

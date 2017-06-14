defmodule Okasaki.Queue do
  @moduledoc """
  Okasaki.Queue
  is a Purely Functional Queue that performs both insertion and removal at guaranteed O(1) (constant) time.
  """

  defstruct left: [], right: [], lefthat: [], size: 0

  def new do
    %__MODULE__{}
  end

  def size(%__MODULE__{size: size}) do
    size
  end

  def to_list(%__MODULE__{left: left, right: right}) do
    left ++ :lists.reverse(right)
  end

  def insert(queue, item) do
    make_queue(queue.left, [item | queue.right], queue.lefthat, queue.size + 1)
  end

  def remove(queue) do
    case queue.left do
      [] ->
        {:error, :empty_queue}
      [item | left_tail] ->
        result = {item, make_queue(left_tail, queue.right, queue.lefthat, queue.size - 1)}
        {:ok, result}
    end
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
end

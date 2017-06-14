defmodule Okasaki.Deque do
  defstruct left: [], right: [], lefthat: [], righthat: [], size: 0
  @moduledoc """
  ODeque is an implementation of Chris Okasaki's
  Purely Functional Deque

  This means that pushing and popping to both ends of the double-ended-queue
  happen in constant (O(1)) time.

  For the paper upon which this is based:
  http://www.westpoint.edu/eecs/SiteAssets/SitePages/Faculty%20Publication%20Documents/Okasaki/jfp95queue.pdf
  """

  @c 3

  def new() do
    %__MODULE__{}
  end

  def size(odeque) do
    odeque.size
  end

  def to_list(odeque) do
    odeque.left ++ :lists.reverse(odeque.right)
  end

  def insert_left(odeque, item) do
    makedeque([item | odeque.left], odeque.right, safe_tl(odeque.lefthat), safe_tl(odeque.righthat), odeque.size + 1)
  end

  def insert_right(odeque, item) do
    makedeque(odeque.left, [item | odeque.right], safe_tl(odeque.lefthat), safe_tl(odeque.righthat), odeque.size + 1)
  end

  # Only zero or one item in dequeue
  def remove_left(%__MODULE__{left: left, right: right}) when length(left) == 0 do
    case right do
      [] -> {:error, :empty_odeque}
      [item | _] -> {:ok, {item, new()}}
    end
  end

  def remove_left(odeque = %__MODULE__{}) do
    [item | left] = odeque.left
    result = {item, makedeque(left, odeque.right, safe_tl(safe_tl(odeque.lefthat)), safe_tl(safe_tl(odeque.righthat)), odeque.size - 1)}
    {:ok, result}
  end

  # Only zero or one item in dequeue
  def remove_right(%__MODULE__{left: left, right: right}) when length(right) == 0 do
    case left do
      [] -> {:error, :empty_odeque}
      [item | _] -> {:ok, {item, new()}}
    end
  end

  def remove_right(odeque = %__MODULE__{}) do
    [item | right] = odeque.right
    result = {item, makedeque(odeque.left, right, safe_tl(safe_tl(odeque.lefthat)), safe_tl(safe_tl(odeque.righthat)), odeque.size - 1)}
    {:ok, result}
  end

  defp makedeque(left, right, _lefthat, _righthat, size) when (length(left) > (@c * length(right) + 1)) do
    n = div(length(left) + length(right), 2)
    lprime = Enum.take(left, n)
    rprime = rot1(n, right, left)

    %__MODULE__{left: lprime, right: rprime, lefthat: lprime, righthat: rprime, size: size}
  end

  defp makedeque(left, right, _lefthat, _righthat, size) when (length(right) > (@c * length(left) + 1)) do
    n = div(length(left) + length(right), 2)
    lprime = rot1(n, left, right)
    rprime = Enum.take(right, n)

    %__MODULE__{left: lprime, right: rprime, lefthat: lprime, righthat: rprime, size: size}
  end

  defp makedeque(left, right, lefthat, righthat, size) do
    %__MODULE__{left: left, right: right, lefthat: lefthat, righthat: righthat, size: size}
  end

  defp rot1(n, left, right) when n >= @c do
    [hd(left) | rot1(n - @c, tl(left), Enum.drop(right, @c))]
  end

  defp rot1(n, left, right) when n < @c do
    rot2(left, Enum.drop(right, n), [])
  end

  defp rot2(left, right, accum) when length(left) > 0 and length(right) >= @c do
    [hd(left) | rot2(tl(left), Enum.drop(right, @c), :lists.reverse(Enum.take(right, @c)) ++ accum)]
  end

  defp rot2(left, right, accum) when length(left) == 0 or length(right) < @c do
    left ++ :lists.reverse(right) ++ accum
  end

  defp safe_tl([]), do: []
  defp safe_tl(list), do: tl(list)
end

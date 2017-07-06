defmodule Okasaki.Implementations.ConstantDeque do
  defstruct left: [], right: [], lefthat: [], righthat: [], size: 0
  @moduledoc """
  Deque is an implementation of Chris Okasaki's
  Purely Functional Deque

  This means that pushing and popping to both ends of the double-ended-queue
  happen in constant (O(1)) time.

  For the paper upon which this is based:
  http://www.westpoint.edu/eecs/SiteAssets/SitePages/Faculty%20Publication%20Documents/Okasaki/jfp95queue.pdf
  """

  @c 3

  @opaque t :: %__MODULE__{
    size: integer,
    left: list,
    right: list,
    lefthat: list,
    righthat: list
  }

  @spec empty(opts :: keyword) :: t
  def empty(_opts \\ []) do
    %__MODULE__{}
  end

  @spec size(t) :: non_neg_integer
  def size(_deque = %__MODULE__{size: size}) do
    size
  end

  @spec empty?(t) :: boolean
  def empty?(%__MODULE__{left: [], right: []}), do: true
  def empty?(%__MODULE__{}), do: false

  @spec to_list(t) :: list
  def to_list(deque) do
    deque.left ++ :lists.reverse(deque.right)
  end

  @spec insert_left(t, item :: any) :: t
  def insert_left(deque, item) do
    makedeque([item | deque.left], deque.right, safe_tl(deque.lefthat), safe_tl(deque.righthat), deque.size + 1)
  end

  @spec insert_right(t, item :: any) :: t
  def insert_right(deque, item) do
    makedeque(deque.left, [item | deque.right], safe_tl(deque.lefthat), safe_tl(deque.righthat), deque.size + 1)
  end

  @spec remove_left(t) :: {:ok, {any, t}} | {:error, :empty}
  # Only zero or one item in dequeue
  def remove_left(%__MODULE__{left: left, right: right}) when length(left) == 0 do
    case right do
      [] -> {:error, :empty}
      [item | _] -> {:ok, {item, empty()}}
    end
  end

  def remove_left(deque = %__MODULE__{}) do
    [item | left] = deque.left
    result = {item, makedeque(left, deque.right, safe_tl(safe_tl(deque.lefthat)), safe_tl(safe_tl(deque.righthat)), deque.size - 1)}
    {:ok, result}
  end


  @spec remove_right(t) :: {:ok, {any, t}} | {:error, :empty}
  # Only zero or one item in dequeue
  def remove_right(%__MODULE__{left: left, right: right}) when length(right) == 0 do
    case left do
      [] -> {:error, :empty}
      [item | _] -> {:ok, {item, empty()}}
    end
  end

  def remove_right(deque = %__MODULE__{}) do
    [item | right] = deque.right
    result = {item, makedeque(deque.left, right, safe_tl(safe_tl(deque.lefthat)), safe_tl(safe_tl(deque.righthat)), deque.size - 1)}
    {:ok, result}
  end

  @spec member?(t, item :: any) :: boolean
  def member?(queue, item) do
    item in queue.left or item in queue.right
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


  defimpl Okasaki.Protocols.Queue do
    def insert(queue, item), do: @for.insert_right(queue, item)
    def remove(queue), do: @for.remove_left(queue)
    def to_list(queue), do: @for.to_list(queue)
    def member?(queue, item), do: @for.member?(queue, item)
    def size(queue), do: @for.size(queue)
    def empty?(queue), do: @for.empty?(queue)
  end

  defimpl Okasaki.Protocols.Deque do
    def insert_left(deque, item), do: @for.insert_left(deque, item)
    def remove_left(deque), do: @for.remove_left(deque)
    def insert_right(deque, item), do: @for.insert_right(deque, item)
    def remove_right(deque), do: @for.remove_right(deque)
    def to_list(deque), do: @for.to_list(deque)
    def member?(queue, item), do: @for.member?(queue, item)
    def size(queue), do: @for.size(queue)
    def empty?(queue), do: @for.empty?(queue)
  end
end

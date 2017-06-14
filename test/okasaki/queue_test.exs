defmodule Okasaki.QueueTest do
  use ExUnit.Case

  alias Okasaki.Queue

  doctest Okasaki.Queue

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "creation and to_list" do
    assert Queue.new() |> Queue.to_list() == []
  end

  test "insert" do
    deque =
      Queue.new()
      |> Queue.insert(1)
      |> Queue.insert(2)
      |> Queue.insert(3)
      |> Queue.insert(4)
      |> Queue.insert(5)
    assert Queue.to_list(deque) == [1,2,3,4,5]
  end

  test "remove" do
    deque =
      Queue.new()
      |> Queue.insert(1)
      |> Queue.insert(2)
      |> Queue.insert(3)
    {:ok, {val, deque_rest}} = Queue.remove(deque)
    assert val == 1
    assert Queue.to_list(deque_rest) == [2,3]
  end
end

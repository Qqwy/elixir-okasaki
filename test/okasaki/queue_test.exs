defmodule Okasaki.QueueTest do
  use ExUnit.Case

  alias Okasaki.Queue

  doctest Okasaki.Queue

  test "creation and to_list" do
    assert Queue.new() |> Queue.to_list() == []
  end

  test "size" do
    queue =
      Queue.new()
      |> Queue.insert(1)
      |> Queue.insert(2)
      |> Queue.insert(3)
      |> Queue.insert(4)
      |> Queue.insert(5)
    assert Queue.size(queue) == 5
  end

  test "insert" do
    queue =
      Queue.new()
      |> Queue.insert(1)
      |> Queue.insert(2)
      |> Queue.insert(3)
      |> Queue.insert(4)
      |> Queue.insert(5)
    assert Queue.to_list(queue) == [1,2,3,4,5]
  end

  test "remove" do
    queue =
      Queue.new()
      |> Queue.insert(1)
      |> Queue.insert(2)
      |> Queue.insert(3)
    {:ok, {val, queue_rest}} = Queue.remove(queue)
    assert val == 1
    assert Queue.to_list(queue_rest) == [2,3]
  end
end

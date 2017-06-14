defmodule Okasaki.DequeTest do
  use ExUnit.Case

  alias Okasaki.ConstantDeque, as: Deque

  doctest Okasaki.ConstantDeque

  test "creation and to_list" do
    assert Deque.new() |> Deque.to_list() == []
  end


  test "size" do
    deque =
      Deque.new()
      |> Deque.insert_right(1)
      |> Deque.insert_right(2)
      |> Deque.insert_right(3)
      |> Deque.insert_right(4)
      |> Deque.insert_right(5)
    assert Deque.size(deque) == 5
  end

  test "insert_left" do
    deque =
      Deque.new()
      |> Deque.insert_left(1)
      |> Deque.insert_left(2)
      |> Deque.insert_left(3)
      |> Deque.insert_left(4)
      |> Deque.insert_left(5)
    assert Deque.to_list(deque) == [5,4,3,2,1]
  end

  test "insert_right" do
    deque =
      Deque.new()
      |> Deque.insert_right(1)
      |> Deque.insert_right(2)
      |> Deque.insert_right(3)
      |> Deque.insert_right(4)
      |> Deque.insert_right(5)
    assert Deque.to_list(deque) == [1,2,3,4,5]
  end

  test "remove_left" do
    deque =
      Deque.new()
      |> Deque.insert_left(1)
      |> Deque.insert_left(2)
      |> Deque.insert_left(3)
    {:ok, {val, deque_rest}} = Deque.remove_left(deque)
    assert val == 3
    assert Deque.to_list(deque_rest) == [2,1]
  end

  test "remove_right" do
    deque =
      Deque.new()
      |> Deque.insert_left(1)
      |> Deque.insert_left(2)
      |> Deque.insert_left(3)
    {:ok, {val, deque_rest}} = Deque.remove_right(deque)
    assert val == 1
    assert Deque.to_list(deque_rest) == [3,2]
  end

end

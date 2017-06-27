defmodule Okasaki.DequeTest do
  use ExUnit.Case

  alias Okasaki.Deque, as: Deque

  doctest Deque

  for impl <- [
        Okasaki.Implementations.AmortizedDeque,
        Okasaki.Implementations.ConstantDeque,
      ] do

      test "#{impl} creation and to_list" do
        assert Deque.new(unquote(impl)) |> Deque.to_list() == []
      end

      test "#{impl} size" do
        deque =
          Deque.new(unquote(impl))
          |> Deque.insert_right(1)
          |> Deque.insert_right(2)
          |> Deque.insert_right(3)
          |> Deque.insert_right(4)
          |> Deque.insert_right(5)
        assert Deque.size(deque) == 5
      end

      test "#{impl} insert_left" do
        deque =
          Deque.new(unquote(impl))
          |> Deque.insert_left(1)
          |> Deque.insert_left(2)
          |> Deque.insert_left(3)
          |> Deque.insert_left(4)
          |> Deque.insert_left(5)
        assert Deque.to_list(deque) == [5,4,3,2,1]
      end

      test "#{impl} insert_right" do
        deque =
          Deque.new(unquote(impl))
          |> Deque.insert_right(1)
          |> Deque.insert_right(2)
          |> Deque.insert_right(3)
          |> Deque.insert_right(4)
          |> Deque.insert_right(5)
        assert Deque.to_list(deque) == [1,2,3,4,5]
      end

      test "#{impl} remove_left" do
        deque =
          Deque.new(unquote(impl))
          |> Deque.insert_left(1)
          |> Deque.insert_left(2)
          |> Deque.insert_left(3)
        {:ok, {val, deque_rest}} = Deque.remove_left(deque)
        assert val == 3
        assert Deque.to_list(deque_rest) == [2,1]
      end

      test "#{impl} remove_right" do
        deque =
          Deque.new(unquote(impl))
          |> Deque.insert_left(1)
          |> Deque.insert_left(2)
          |> Deque.insert_left(3)
        {:ok, {val, deque_rest}} = Deque.remove_right(deque)
        assert val == 1
        assert Deque.to_list(deque_rest) == [3,2]
      end


      test "Insertable and Extractable protocol implementations for #{impl}" do
        {:ok, res} = Okasaki.Queue.new() |> Insertable.insert(10);
        {:ok, res} = Insertable.insert(res, 20);
        {:ok, {item, res}} = Extractable.extract(res)
        assert item == 10
        assert Extractable.extract(res) == {:ok, {20, Okasaki.Queue.new()}}
      end
  end
end

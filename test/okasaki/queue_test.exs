defmodule Okasaki.QueueTest do
  use ExUnit.Case

  alias Okasaki.Queue, as: Queue

  doctest Queue

  for impl <- [
        Okasaki.Implementations.ConstantQueue,
        Okasaki.Implementations.AmortizedQueue,

        Okasaki.Implementations.AmortizedDeque,
        Okasaki.Implementations.ConstantDeque,
      ] do

      test "#{impl} creation and to_list" do
        assert Queue.empty(implementation: unquote(impl)) |> Queue.to_list() == []
      end

      test "#{impl} size" do
        queue =
          Queue.empty(implementation: unquote(impl))
          |> Queue.insert(1)
          |> Queue.insert(2)
          |> Queue.insert(3)
          |> Queue.insert(4)
          |> Queue.insert(5)
        assert Queue.size(queue) == 5
      end

      test "#{impl} insert" do
        queue =
          Queue.empty(implementation: unquote(impl))
          |> Queue.insert(1)
          |> Queue.insert(2)
          |> Queue.insert(3)
          |> Queue.insert(4)
          |> Queue.insert(5)
        assert Queue.to_list(queue) == [1,2,3,4,5]
      end

      test "#{impl} remove" do
        queue =
          Queue.empty(implementation: unquote(impl))
          |> Queue.insert(1)
          |> Queue.insert(2)
          |> Queue.insert(3)
        {:ok, {val, queue_rest}} = Queue.remove(queue)
        assert val == 1
        assert Queue.to_list(queue_rest) == [2,3]
      end

      test "#{impl} take_while" do
        {result, _resulting_queue} =
          [1,2,3,4]
          |> Enum.into(%unquote(impl){})
          |> Okasaki.Queue.take_while(fn x -> x < 3 end)
        assert result == Enum.into([1,2], %unquote(impl){})
      end

      test "Insertable and Extractable protocol implementations for #{impl}" do
        {:ok, res} = Okasaki.Queue.empty(implementation: unquote(impl)) |> Insertable.insert(10);
        {:ok, res} = Insertable.insert(res, 20);
        {:ok, {item, res}} = Extractable.extract(res)
        assert item == 10
        assert Extractable.extract(res) == {:ok, {20, Okasaki.Queue.empty(implementation: unquote(impl))}}
      end
  end
end

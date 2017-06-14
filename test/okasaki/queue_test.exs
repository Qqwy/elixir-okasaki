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
        assert Queue.new(unquote(impl)) |> Queue.to_list() == []
      end

      test "#{impl} size" do
        queue =
          Queue.new(unquote(impl))
          |> Queue.insert(1)
          |> Queue.insert(2)
          |> Queue.insert(3)
          |> Queue.insert(4)
          |> Queue.insert(5)
        assert Queue.size(queue) == 5
      end

      test "#{impl} insert" do
        queue =
          Queue.new(unquote(impl))
          |> Queue.insert(1)
          |> Queue.insert(2)
          |> Queue.insert(3)
          |> Queue.insert(4)
          |> Queue.insert(5)
        assert Queue.to_list(queue) == [1,2,3,4,5]
      end

      test "#{impl} remove" do
        queue =
          Queue.new(unquote(impl))
          |> Queue.insert(1)
          |> Queue.insert(2)
          |> Queue.insert(3)
        {:ok, {val, queue_rest}} = Queue.remove(queue)
        assert val == 1
        assert Queue.to_list(queue_rest) == [2,3]
      end

      test "#{impl} take_while" do
        {result, resulting_queue} =
          [1,2,3,4]
          |> Enum.into(%Okasaki.Implementations.AmortizedQueue{})
          |> Okasaki.Queue.take_while(fn x -> false end)
        assert result == []
      end
  end
end

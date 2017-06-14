# This file contains implementations of common protocols
# That are shared by the different (double-ended) queue types.

# Implementations for all
for module <- [
      Okasaki.Implementations.ConstantDeque,

      Okasaki.Implementations.ConstantQueue,
      Okasaki.Implementations.AmortizedQueue
    ] do
    defimpl Inspect, for: module do
      import Inspect.Algebra

      def inspect(deque, _opts) do
        concat ["##{inspect(@for)}<", inspect(@for.to_list(deque)) ,">"]
      end
    end
end


# Implementations only for queues
for module <- [
      Okasaki.Implementations.ConstantQueue,
      Okasaki.Implementations.AmortizedQueue,
    ] do

    defimpl Collectable, for: module do
      def into(original) do
        {original, fn
          queue, {:cont, value} -> @for.insert(queue, value)
          queue, :done -> queue
          _, :halt -> :ok
        end}
      end
    end

    defimpl Enumerable, for: module do
      def reduce(_, {:halt, acc}, _fun) do
        {:halted, acc}
      end

      def reduce(queue, {:suspend, acc}, fun) do
        {:suspended, acc, &reduce(queue, &1, fun)}
      end

      def reduce(queue, {:cont, acc}, fun) do
        case @for.remove(queue) do
          {:ok, {item, queue}} ->
            reduce(queue, fun.(item, acc), fun)
          {:error, :empty} ->
            {:done, acc}
        end
      end

      def member?(queue, item) do
        @for.member?(queue, item)
      end

      def count(queue) do
        {:ok, @for.size(queue)}
      end

    end
end

# Implementations only for deques
for module <- [
      Okasaki.Implementations.ConstantDeque,
    ] do

    defimpl Collectable, for: module do
      def into(original) do
        {original, fn
          queue, {:cont, value} -> @for.insert_right(queue, value)
          queue, :done -> queue
          _, :halt -> :ok
        end}
      end
    end

    defimpl Enumerable, for: module do
      def reduce(_, {:halt, acc}, _fun) do
        {:halted, acc}
      end

      def reduce(deque, {:suspend, acc}, fun) do
        {:suspended, acc, &reduce(deque, &1, fun)}
      end

      def reduce(deque, {:cont, acc}, fun) do
        case @for.remove_left(deque) do
          {:ok, {item, deque}} ->
            reduce(deque, fun.(item, acc), fun)
          {:error, :empty} ->
            {:done, acc}
        end
      end

      def member?(deque, item) do
        {:ok, @for.member?(deque, item)}
      end

      def count(deque) do
        {:ok, @for.size(deque)}
      end
    end

end

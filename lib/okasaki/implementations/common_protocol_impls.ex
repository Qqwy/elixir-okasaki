# This file contains implementations of common protocols
# That are shared by the different (double-ended) queue types.

# Implementations for all
for module <- [
      Okasaki.Implementations.AmortizedQueue,
      Okasaki.Implementations.ConstantQueue,
      Okasaki.Implementations.ErlangQueue,

      Okasaki.Implementations.AmortizedDeque,
      Okasaki.Implementations.ConstantDeque,
      Okasaki.Implementations.ErlangDeque,
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
      Okasaki.Implementations.AmortizedQueue,
      Okasaki.Implementations.ConstantQueue,
      Okasaki.Implementations.ErlangQueue,
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

    defimpl Insertable, for: module do
      def insert(collection, item) do
        {:ok, @for.insert(collection, item)}
      end
    end

    defimpl Extractable, for: module do
      def extract(collection) do
        case @for.remove(collection) do
          {:error, :empty} -> :error
          {:ok, {item, collection}} -> {:ok, {item, collection}}
        end
      end
    end
end

# Implementations only for deques
for module <- [
      Okasaki.Implementations.AmortizedDeque,
      Okasaki.Implementations.ConstantDeque,
      Okasaki.Implementations.ErlangDeque,
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

    defimpl Insertable, for: module do
      def insert(collection, item) do
        {:ok, @for.insert_right(collection, item)}
      end
    end

    defimpl Extractable, for: module do
      def extract(collection) do
        case @for.remove_left(collection) do
          {:error, :empty} -> :error
          {:ok, {item, collection}} -> {:ok, {item, collection}}
        end
      end
    end
end

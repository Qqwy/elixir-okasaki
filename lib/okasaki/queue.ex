defmodule Okasaki.Queue do
  @moduledoc """
  Public interface to work with queue-like structures.
  """

  @default_queue_implementation Okasaki.Implementations.ConstantQueue
  @doc """
  Returns a new empty queue.

  Optionally, the `implementation: SomeModuleName` can be passed.
  (See the list of implementations in the module documentation of the `Okasaki` module.)

  This can also be overridden on an application-wide level, by the configuration:

  ```elixir
  config :okasaki, default_queue_implementation: Queue.Implementation.Module.Name
  ```

  By default, `#{inspect(@default_queue_implementation)}` is used.
  """
  def empty(opts \\ []) do
    implementation = Keyword.get(opts, :implementation, Application.get_env(:okasaki, :default_queue_implementation, @default_queue_implementation) )
    implementation.empty()
  end

  @doc """
  Creates a new deque.

  The first parameter is an enumerable that the queue will be filled with.
  The second parameter is a list of options, which are the same as `empty/1` expects.
  """
  def new(enumerable \\ [], opts \\ []) do
    Enum.into(enumerable, empty(opts))
  end

  @doc """
  Transforms the queue into a list.
  """
  defdelegate to_list(queue), to: Okasaki.Protocols.Queue

  @doc """
  Inserts a new element into the end of the queue. Returns the new queue.
  """
  defdelegate insert(queue, item), to: Okasaki.Protocols.Queue

  @doc """
  Attempts to remove the front element of the queue:

  - Returns `{:error, :empty}` if the queue is empty.
  - Returns `{:ok, {item, queue_without_item}}` if it succeeded.
  """
  defdelegate remove(queue), to: Okasaki.Protocols.Queue

  @doc """
  Checks if `item` is one of the elements inside of `queue`.

  Uses Erlang's built-in structural term comparison.
  """
  defdelegate member?(queue, item), to: Okasaki.Protocols.Queue

  @doc """
  Returns the number of elements inside the queue.
  For most queue implementations, this is a O(1) procedure,
  because the size is explicitly kept.
  """
  defdelegate size(queue), to: Okasaki.Protocols.Queue

  @doc """
  True if the queue does not contain any elements.
  """
  defdelegate empty?(queue), to: Okasaki.Protocols.Queue

  @doc """
  A function to remove elements from the front of a queue,
  until the function returns false.

  Then, returns {list_of_removed_items, rest_of_queue}

  In contrast to `Enum.split_while`, the unused rest of the queue
  is not suddenly transformed into a list, but is still a queue.
  """
  def take_while(queue = %queue_impl{}, fun), do: take_while(queue, fun, queue_impl.empty())
  defp take_while(queue, fun, accum) do
    case remove(queue) do
      {:ok, {item, altered_queue}} ->
        if fun.(item) do
          take_while(altered_queue, fun, insert(accum, item))
        else
          {accum, queue}
        end
      {:error, :empty} ->
        {accum, queue}
    end
  end
end

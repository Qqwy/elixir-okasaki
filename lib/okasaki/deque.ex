defmodule Okasaki.Deque do
  @moduledoc """
  Public interface to work with double-ended queue-like structures.
  """

  @default_deque_implementation Okasaki.Implementations.ConstantDeque
  @doc """
  Returns a new empty deque.

  Optionally, the `implementation: SomeModuleName` can be passed.
  (See the list of implementations in the module documentation of the `Okasaki` module.)

  This can also be overridden on an application-wide level, by the configuration:

  ```elixir
  config :okasaki, default_deque_implementation: Deque.Implementation.Module.Name
  ```

  By default, `#{inspect(@default_deque_implementation)}` is used.
  """
  def empty(opts \\ []) do
    implementation = Keyword.get(opts, :implementation, Application.get_env(:okasaki, :default_deque_implementation, Okasaki.Implementations.ConstantDeque) )
    implementation.empty()
  end


  @doc """
  Createas a new deque.

  The first parameter is an enumerable that the deque will be filled with.
  The second parameter is a list of options, which are the same as `empty/1` expects.
  """
  def new(enumerable \\ [], opts \\ []) do
    Enum.into(enumerable, empty(opts))
  end

  @doc """
  Transforms the deque into a list.
  """
  defdelegate to_list(deque), to: Okasaki.Protocols.Deque

  @doc """
  Inserts a new element into the leftmost ('front') end of the deque. Returns the new deque.
  """
  defdelegate insert_left(deque, item), to: Okasaki.Protocols.Deque

  @doc """
  Inserts a new element into the rightmost ('back') end of the deque. Returns the new deque.
  """
  defdelegate insert_right(deque, item), to: Okasaki.Protocols.Deque

  @doc """
  Attempts to remove the leftmost ('front') element of the deque:

  - Returns `{:error, :empty}` if the deque is empty.
  - Returns `{:ok, {item, deque_without_item}}` if it succeeded.
  """
  defdelegate remove_left(deque), to: Okasaki.Protocols.Deque

  @doc """
  Attempts to remove the rightmost ('back') element of the deque:

  - Returns `{:error, :empty}` if the deque is empty.
  - Returns `{:ok, {item, deque_without_item}}` if it succeeded.
  """
  defdelegate remove_right(deque), to: Okasaki.Protocols.Deque

  @doc """
  Checks if `item` is one of the elements inside of `deque`.

  Uses Erlang's built-in structural term comparison.
  """
  defdelegate member?(deque, item), to: Okasaki.Protocols.Deque

  @doc """
  Returns the number of elements inside the deque.
  For most deque implementations, this is a O(1) procedure,
  because the size is explicitly kept.
  """
  defdelegate size(deque), to: Okasaki.Protocols.Deque

  @doc """
  True if the deque does not contain any elements.
  """
  defdelegate empty?(deque), to: Okasaki.Protocols.Deque

  @doc """
  A function to remove elements from the front of a deque,
  until the function returns false.

  Then, returns {list_of_removed_items, rest_of_deque}

  In contrast to `Enum.split_while`, the unused rest of the deque
  is not suddenly transformed into a list, but is still a deque.
  """
  def take_while(deque = %deque_impl{}, fun), do: take_while(deque, fun, deque_impl.empty())
  defp take_while(deque, fun, accum) do
    case remove_right(deque) do
      {:ok, {item, altered_deque}} ->
        if fun.(item) do
          take_while(altered_deque, fun, insert_left(accum, item))
        else
          {accum, deque}
        end
      {:error, :empty} ->
        {accum, deque}
    end
  end
end

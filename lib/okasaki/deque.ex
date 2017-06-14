defmodule Okasaki.Deque do

  def new() do
    implementation = Application.get_env(:okasaki, :default_deque_implementation, Okasaki.Implementations.ConstantQueue)
    implementation.new()
  end

  def new(implementation) do
    implementation.new()
  end

  defdelegate to_list(queue), to: Okasaki.Protocols.Deque
  defdelegate insert_left(queue, item), to: Okasaki.Protocols.Deque
  defdelegate insert_right(queue, item), to: Okasaki.Protocols.Deque
  defdelegate remove_left(queue), to: Okasaki.Protocols.Deque
  defdelegate remove_right(queue), to: Okasaki.Protocols.Deque
  defdelegate size(deque), to: Okasaki.Protocols.Deque


  def take_while(queue, fun), do: take_while(queue, fun, [])
  defp take_while(queue, fun, accum) do
    case Okasaki.Protocols.Deque.remove_left(queue) do
      {:ok, {item, altered_queue}} ->
        if fun.(item) do
          take_while(altered_queue, fun, [item | accum])
        else
          {:lists.reverse(accum), queue}
        end
      {:error, :empty} ->
        {:lists.reverse(accum), queue}
    end
  end
end

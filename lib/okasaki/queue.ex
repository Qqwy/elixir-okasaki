defmodule Okasaki.Queue do

  def new() do
    implementation = Application.get_env(:okasaki, :default_queue_implementation, Okasaki.Implementations.ConstantQueue)
    implementation.new()
  end

  def new(implementation) do
    implementation.new()
  end

  defdelegate to_list(queue), to: Okasaki.Protocols.Queue
  defdelegate insert(queue, item), to: Okasaki.Protocols.Queue
  defdelegate remove(queue), to: Okasaki.Protocols.Queue
  defdelegate member?(queue, item), to: Okasaki.Protocols.Queue
  defdelegate size(queue), to: Okasaki.Protocols.Queue

  def take_while(queue = %queue_impl{}, fun), do: take_while(queue, fun, queue_impl.new())
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

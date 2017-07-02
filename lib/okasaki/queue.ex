defmodule Okasaki.Queue do
  def empty(opts \\ []) do
    implementation = Keyword.get(opts, :implementation, Application.get_env(:okasaki, :default_queue_implementation, Okasaki.Implementations.ConstantDeque) )
    implementation.empty()
  end

  def new(enumerable \\ [], opts \\ []) do
    Enum.into(enumerable, empty(opts))
  end

  defdelegate to_list(queue), to: Okasaki.Protocols.Queue
  defdelegate insert(queue, item), to: Okasaki.Protocols.Queue
  defdelegate remove(queue), to: Okasaki.Protocols.Queue
  defdelegate member?(queue, item), to: Okasaki.Protocols.Queue
  defdelegate size(queue), to: Okasaki.Protocols.Queue

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

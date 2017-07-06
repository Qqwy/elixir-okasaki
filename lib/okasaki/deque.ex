defmodule Okasaki.Deque do

  def empty(opts \\ []) do
    implementation = Keyword.get(opts, :implementation, Application.get_env(:okasaki, :default_deque_implementation, Okasaki.Implementations.ConstantDeque) )
    implementation.empty()
  end

  def new(enumerable \\ [], opts \\ []) do
    Enum.into(enumerable, empty(opts))
  end

  defdelegate to_list(queue), to: Okasaki.Protocols.Deque
  defdelegate insert_left(queue, item), to: Okasaki.Protocols.Deque
  defdelegate insert_right(queue, item), to: Okasaki.Protocols.Deque
  defdelegate remove_left(queue), to: Okasaki.Protocols.Deque
  defdelegate remove_right(queue), to: Okasaki.Protocols.Deque
  defdelegate size(deque), to: Okasaki.Protocols.Deque
  defdelegate empty?(queue), to: Okasaki.Protocols.Deque

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

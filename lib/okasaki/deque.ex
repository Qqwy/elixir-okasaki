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
end

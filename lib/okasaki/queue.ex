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
end

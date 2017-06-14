defmodule Okasaki.Queue do
  def new(implementation \\ Okasaki.Implementations.ConstantQueue) do
    implementation.new()
  end

  defdelegate to_list(queue), to: Okasaki.Protocols.Queue
  defdelegate insert(queue, item), to: Okasaki.Protocols.Queue
  defdelegate remove(queue), to: Okasaki.Protocols.Queue
end

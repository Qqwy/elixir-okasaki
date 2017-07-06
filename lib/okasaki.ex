defmodule Okasaki do
  @moduledoc """
  Well-structured Queues for Elixir, offering a common interface with multiple implementations with varying performance guarantees that can be switched in your configuration.

  ## Simple Usage Example:

      iex> queue =  Okasaki.Queue.new([1,2,3,4])
      #Okasaki.Implementations.ConstantQueue<[1, 2, 3, 4]>
      iex> queue = Okasaki.Queue.insert(queue, 42)
      #Okasaki.Implementations.ConstantQueue<[1, 2, 3, 4, 42]>
      iex> Okasaki.Queue.empty?(queue)
      false
      iex> Okasaki.Queue.size(queue)
      5
      iex> {:ok, {item, rest_queue}} = Okasaki.Queue.remove(queue)
      iex> item
      1
      iex> rest_queue
      #Okasaki.Implementations.ConstantQueue<[2, 3, 4, 42]>

  ## Built-In Implementations:

  Switching between implementations can be done once your application is up-and-running after benchmarking on a application-configuration-wide level, using e.g.:

  ```elixir
  config :okasaki, default_queue_implementation: Okasaki.Implementations.ErlangQueue,
  default_deque_implementation: Okasaki.Implementations.AmortizedDeque
  ```
  Or on a per-call basis, using `Okasaki.Queue.new([1,2,3], implementation: Okasaki.Implementations.ConstantQueue)`


  ### AmortizedQueue/AmortizedDeque

  A simple implementation in Elixir of a queue consisting of two lists, where we reverse the other list when one is empty.
  This results in an _amortized_ O(1) remove speed, which for some implementations is not good enough.
  However, the implementation is very simple to read.

  ### ConstantQueue/ConstantDeque

  Based on the work by Chris Okasaki, this is a version that keeps an invariant to ensure that no ad-hoc reversals are necessary.
  This means we have a _constant_ O(1) remove speed.
  The implementation is slightly more involved than the Amortized version though, which means that it might be slower for some
  inputs.

  ### ErlangQueue/ErlangDeque

  These are simple wrappers around Erlang's built-in `:queue` module, which is also a version of an amortized deque.
  `:queue` itself however exposes a bit of a peculiar API (Or actually interweaves three different naming schemes whose functionality partially overlaps),
  and by using ErlangQueue or ErlangDeque from within Okasaki, you get a bunch of protocols that are supported as well.


  ## Implemented Protocols and Behaviours

  These are the protocols and behaviours that are implemented by the built-in Queue/Deque implementations.
  If you want to build your own implementation and use it with the Okasaki functions,
  it is strongly recommended to implement all of these protocols and behaviours for your data structure,
  so user code will be able to properly handle your custom implementation.

  ### Okasaki.Queue.Protocol, Okasaki.Deque.Protocol

  Contains most of the queries that are done for doing resp. queue/deque-specific things.

  ### Extractable

  A common interface to extract items one-by-one from a collection.

  ### Insertable

  A common interface to insert items one-by-one into a collection.

  ### Enumerable

  The Elixir protocol to allow extracting a whole bunch of items at once from a collection.

  ### Collectable

  the Elixir protocol to allow inserting a whole bunch of items at once into a collection.

  ### FunLand.Mappable

  The FunLand behaviour that allows mapping a function over all values in the collection, keeping the structure the same.

  ### Inspect

  A humanly-readable debugging protocol to show you how the different queues and deques look,
  without needing to decypher the internal storage mechanisms.

  """
end

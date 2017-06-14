for module <- [
      Okasaki.Implementations.ConstantDeque,
      Okasaki.Implementations.ConstantQueue,
      Okasaki.Implementations.AmortizedQueue
    ] do
    defimpl Inspect, for: module do
      import Inspect.Algebra

      def inspect(deque, _opts) do
        concat ["##{inspect(@for)}<", inspect(@for.to_list(deque)) ,">"]
      end
    end
end

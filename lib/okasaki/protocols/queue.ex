defprotocol Okasaki.Protocols.Queue do
  @doc """
  Inserts a new item to the end of the queue.
  """
  @spec insert(t, item :: any) :: t
  def insert(queue, item)

  @doc """
  Removes an item from the front of the queue.
  """
  @spec remove(t) :: {:ok, {item :: any, t}} | {:error, :empty}
  def remove(queue)

  @doc """
  Converts the queue to a list.
  """
  @spec to_list(t) :: list
  def to_list(queue)
end

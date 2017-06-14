defprotocol Okasaki.Protocols.Deque do
  @doc """
  Inserts a new item to the left end of the deque.
  """
  @spec insert_left(t, item :: any) :: t
  def insert_left(deque, item)

  @doc """
  Inserts a new item to the right end of the deque.
  """
  @spec insert_right(t, item :: any) :: t
  def insert_right(deque, item)

  @doc """
  Removes an item from the left side of the deque.
  """
  @spec remove_left(t) :: {:ok, {item :: any, t}} | {:error, :empty}
  def remove_left(deque)

  @doc """
  Removes an item from the right side of the deque.
  """
  @spec remove_right(t) :: {:ok, {item :: any, t}} | {:error, :empty}
  def remove_right(deque)

  @doc """
  Converts the deque to a list.
  """
  @spec to_list(t) :: list
  def to_list(deque)

  @doc """
  Checks if a certain element is part of the deque.
  """
  def member?(queue, item)
end

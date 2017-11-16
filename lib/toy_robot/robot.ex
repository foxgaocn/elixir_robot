alias ToyRobot.Direction

defmodule ToyRobot.Robot do
  use GenServer

  @table_size {5, 5}

  defmodule State do 
    defstruct pos: nil, direction: nil

    def placed?(state = %State{}) do
      state.pos != nil
    end
  end

  ##client side apis
  def start_link() do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)    
  end

  def call(:place, opt) do
    GenServer.call(__MODULE__, {:place, opt})
  end

  def call(action) do
    GenServer.call(__MODULE__, action)
  end


  ##server side apis
  def init(args) do
    {:ok, args}
  end

  def handle_call({:place, {x, y, direction} }, _from, state ) do
    if(valid_pos?(x, y)) do
      {:reply, :ok, %State{state | pos: {x, y}, direction: direction}}
    else
      {:reply, {:error, "invalid place to put"}}
    end
  end

  def handle_call(cmd, _from, state) do
    if(State.placed?(state)) do
      do_action(cmd, state)
    else
      {:reply, {:error, "robot not placed yet"}, state}
    end
  end

  defp do_action(:move, state) do
    {x,y} = state.pos
    case state.direction do
      :north -> state |> try_move_to(x, y+1)
      :east -> state |> try_move_to(x+1, y)
      :south -> state |> try_move_to(x, y-1)
      :west -> state |> try_move_to(x-1, y)
    end
  end

  defp do_action(:report, state) do
    {:reply, {:ok, state}, state}
  end

  defp do_action(:left, state) do
    new_dir = state.direction |> Direction.left
    {:reply, :ok, %State{state | direction: new_dir}}
  end

  defp do_action(:right, state) do
    new_dir = state.direction |> Direction.right
    {:reply, :ok, %State{state | direction: new_dir}}
  end

  defp valid_pos?(x, y) do
    x >= 0 and x < elem(@table_size, 0) and y >=0 and y < elem(@table_size, 1)
  end

  defp try_move_to(state, x, y) do
    if valid_pos?(x, y) do
      {:reply, :ok, %State{state | pos: {x, y}}}
    else
      {:reply, {:error, "Move to an invalid pos"}, state}
    end
  end
end
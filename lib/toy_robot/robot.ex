alias ToyRobot.{Direction, Position}

defmodule ToyRobot.Robot do
  use GenServer

  @table_size {5, 5}

  defmodule State do 
    @type t :: %__MODULE__{pos: Position.t, direction: Direction.t}
    defstruct pos: nil, direction: nil

    def placed?(%State{pos: pos}), do: pos != nil
  end

  ##client side apis
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)    
  end

  def call({:place, position, direction}) do
    GenServer.call(__MODULE__, {:place, position, direction})
  end

  def call({action}) do
    GenServer.call(__MODULE__, action)
  end

  ##server side apis
  def init(args) do
    {:ok, args}
  end

  def handle_call({:place, position, direction }, _from, state ) do
    if(valid_pos?(position)) do
      {:reply, :ok, %State{state | pos: position, direction: direction}}
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
     case state.direction do
      :north -> state.pos |> Position.inc_y |> try_move_to(state)
      :east -> state.pos |> Position.inc_x |> try_move_to(state)
      :south -> state.pos |> Position.dec_y |> try_move_to(state)
      :west -> state.pos |> Position.dec_x |> try_move_to(state)
    end
  end

  defp do_action(:report, state) do
    {:reply, {:ok, "I am on #{elem(state.pos, 0)}, #{elem(state.pos, 1)}, facing #{state.direction}"}, state}
  end

  defp do_action(:left, state) do
    new_dir = state.direction |> Direction.left
    {:reply, :ok, %State{state | direction: new_dir}}
  end

  defp do_action(:right, state) do
    new_dir = state.direction |> Direction.right
    {:reply, :ok, %State{state | direction: new_dir}}
  end

  @spec valid_pos?(Position.t) :: boolean
  defp valid_pos?({x, y}) do
    x >= 0 and x < elem(@table_size, 0) and y >=0 and y < elem(@table_size, 1)
  end

  @spec try_move_to(Position.t, State.t) :: tuple
  defp try_move_to({x, y}, state) do
    if valid_pos?({x, y}) do
      {:reply, :ok, %State{state | pos: {x, y}}}
    else
      {:reply, {:error, "Move to an invalid pos"}, state}
    end
  end
end
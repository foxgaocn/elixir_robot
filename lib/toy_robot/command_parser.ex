alias ToyRobot.PlaceOption

defmodule ToyRobot.CommandParser do
  use GenServer

  @valid_command_no_param ~w(move right left report)

  ###CLIENT API###
  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def process(input) do
      GenServer.call(__MODULE__, {:process, input})
  end

  ###SERVER API
  def handle_call({:process, input}, _from, _state) do
    input
      |> String.trim
      |> String.downcase
      |> String.split(" ", trim: true) 
      |> parse
  end

  defp parse(["place", opt|_]) do
    case PlaceOption.parse(opt) do
      {:ok, position, direction} -> {:reply, {:ok, {:place, position, direction}}, []}
      _ -> {:reply, {:error, "invalid place with options #{opt}"}, []}
    end   
  end

  defp parse(["crash"]) do
    raise "OOPS"
  end

  defp parse(cmd) do
    case cmd do
      [] -> {:reply, :ok, []}
      [cmd] when cmd in @valid_command_no_param -> {:reply, {:ok, {String.to_atom(cmd)}}, []}
      _ -> {:reply, {:error, "invalid command #{cmd}"}, []}
    end
  end
end
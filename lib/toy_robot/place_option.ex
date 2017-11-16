alias ToyRobot.{Direction, Position}

defmodule ToyRobot.PlaceOption do
  @spec parse(binary) :: {:ok, Position.t, Direction.t} | {:error}
  def parse(opt) do
    opt 
      |> String.split(",")
      |> case do
        [x, y, d] -> parse_option(x, y, d)
        _ -> {:error}
      end
  end

  defp parse_option(x, y, d) do
    case [Integer.parse(x), Integer.parse(y), Direction.parse_direction(d) ] do
      [{x, _}, {y, _}, {:ok, d}] -> {:ok, {x,y}, d}
      _ -> {:error}
    end
  end
end
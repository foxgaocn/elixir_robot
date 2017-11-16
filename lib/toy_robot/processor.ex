alias ToyRobot.{Robot, PlaceOption}

defmodule ToyRobot.Processor do
  @valid_command_no_param ~w(move right left report)

  def process(input) do
    input
      |> String.trim
      |> String.downcase
      |> String.split(" ", trim: true) 
      |> get_command_and_options
      |> process_command
  end

  defp get_command_and_options(["place", opt|_]) do
    case PlaceOption.parse(opt) do
      {:ok, position, direction} -> {:place, position, direction}
      _ -> {:invalid, "invalid place with options #{opt}"}
    end   
  end

  defp get_command_and_options(cmd) do
    case cmd do
      [] -> :empty
      [cmd] when cmd in @valid_command_no_param -> String.to_atom(cmd)
      _ -> {:invalid, "invalid command #{cmd}"}
    end
  end

  defp process_command(:empty) do
  end

  defp process_command({:invalid, message}) do
    IO.puts message
  end


  defp process_command({:place, position, direction}) do
    case Robot.call(:place, position, direction) do
      {:error, reason} -> IO.puts("Error: #{reason}")
      _ -> nil
    end
  end

  defp process_command(:report) do
    case Robot.call(:report) do
      {:ok, state} -> IO.puts("Robot on #{elem(state.pos, 0)}, #{elem(state.pos, 1)}, facing #{state.direction}")
      {:error, reason} -> IO.puts("Error: #{reason}")
    end
  end

  defp process_command(cmd) do
    case Robot.call(cmd) do
      {:error, reason} -> IO.puts("Error: #{reason}")
      _ -> nil
    end
  end
end
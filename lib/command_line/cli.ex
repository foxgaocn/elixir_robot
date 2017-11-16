defmodule Commandline.CLI do
  def main(_args) do
    read_from_stdio()
  end

  defp read_from_stdio do
    ToyRobot.Robot.start_link()
    case IO.read(:stdio, :line) do
      :eof -> :ok
      {:error, reason} -> IO.puts "Error: #{reason}"
      input ->
        ToyRobot.Processor.process(input)
    end
    read_from_stdio()
  end
end
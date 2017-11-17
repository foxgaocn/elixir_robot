defmodule ToyRobot.Application do
  alias ToyRobot.{Robot, CommandParser}
  use Application

  def start(_type, _args) do
    children = [
      {ToyRobot.Robot, []},
      {ToyRobot.CommandParser, []}
    ]

    opts = [strategy: :one_for_one, name: ToyRobot.Supervisor]
    Supervisor.start_link(children, opts)
  end


  def run() do
    read_from_stdio()
  end

  defp read_from_stdio do
    case IO.read(:stdio, :line) do
      :eof -> :ok
      {:error, reason} -> "Error: #{reason}" |> IO.puts 
      input ->
        with {:ok, command_with_options} <- CommandParser.process(input),
             {:ok, reply} <- Robot.call(command_with_options)
        do
          reply |> IO.puts
        else
          {:error, reason} -> "Error: #{reason}" |> IO.puts
          :ok -> :ok
        end
    end
    read_from_stdio()
  end
end

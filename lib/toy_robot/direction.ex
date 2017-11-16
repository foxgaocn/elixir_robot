defmodule ToyRobot.Direction do
  @type t :: :north | :east | :south | :west
  
  @valid_direction ~w(north east south west)a

  def parse_direction(d) do
    d
      |> String.downcase
      |> String.to_atom
      |> get
  end

  def left(:north), do: :west
  def left(:east), do: :north
  def left(:west), do: :south
  def left(:south), do: :east

  def right(:north), do: :east
  def right(:east), do: :south
  def right(:west), do: :north
  def right(:south), do: :west

  defp get(d) do
    if Enum.member?(@valid_direction, d), do: {:ok, d}, else: {:error, d}
  end
end
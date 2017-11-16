defmodule ToyRobot.Position do
  @type t :: {non_neg_integer, non_neg_integer}

  @spec inc_x(t) :: t
  def inc_x({x, y}), do: {x+1, y}

  @spec dec_x(t) :: t
  def dec_x({x, y}), do: {x-1, y}

  @spec inc_y(t) :: t
  def inc_y({x, y}), do: {x, y+1}

  @spec dec_y(t) :: t
  def dec_y({x, y}), do: {x, y-1}
end
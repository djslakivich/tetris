defmodule Tetris.Point do
  alias Tetris.{Bottom, Brick, Points, Plots}
  @grid 4

  def rotate(point, 0) do
    point
  end

  def rotate(point, 90) do
    point
    |> transpose
    |> mirror
  end

  def rotate(point, 180) do
    point
    |> mirror
    |> flip
  end

  def rotate(point, 270) do
    point
    |> transpose
    |> flip
  end

  def mirror({x,y}) do
    {@grid-x, y}
  end

  def flip({x,y}) do
    {x, @grid-y}
  end

  def transpose({x,y}) do
    {y,x}
  end

  def move({x,y},{a_x,a_y}) do
    {x + a_x, y + a_y}
  end
end

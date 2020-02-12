defmodule Tetris.Brick do
  @on "[]"
  @off "--"
  @grid 1..4
  defstruct [:name, :rotation, :reflection, :location]

  def print_brick(brick) do
    # this makes a grid, then takes some points from the brick you have supplied, then takes the points of the brick and posts them onto the grid it's made.

    shape = prepare_points(brick)

    for y <- @grid , x <- @grid do
      if {x,y} in shape do
        @on
      else
        @off
      end
    end
    |> Enum.chunk_every(4)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts

    brick
  end
  def print_points(points) do
    # this makes a grid, then takes the points you have already supplied, and prints those points onto the grid

    for y <- @grid , x <- @grid do
      if {x,y} in points do
        @on
      else
        @off
      end
    end
    |> Enum.chunk_every(4)
    |> Enum.map(&Enum.join/1)
    |> Enum.join("\n")
    |> IO.puts

    points
  end
  def prepare_points(brick) do
  # Takes the bricks atom, grabs the points of the atom, then it rotates, reflects it and then finally moves the point.
    brick.name
    |> Plots.points()
    |> Tetris.Points.rotate(brick.rotation)
    |> Tetris.Points.reflect(brick.reflection)
    |> Tetris.Points.move(brick.location)
  end
  def rotate_four(brick) do
    # Multiple points
    prepare_points(brick)
      |> Enum.map( fn point ->
        Point.rotate(brick.rotation, point) end)
  end
  def random_name do
    [:t, :z, :o, :i, :l]
    |> Enum.random
  end
  def random_rotation do
    rotation = [0, 90, 180, 270]
      Enum.random(rotation)
  end
  def random_reflection do
    reflection = [true, false]
      Enum.random(reflection)
  end
  def random_brick do
    # creates a random brick
      n = random_name()
      ro = random_rotation()
      re = random_reflection()
    %__MODULE__{
      name: n,
      rotation: ro,
      reflection: re,
      location: Plots.new_location
    }
  end
  defp toggle(true) do
    false
  end
  defp toggle(false) do
    true
  end
  def reflect(brick) do
    %{brick| reflection: toggle(brick.reflection)}
  end
  def left(brick) do
    %{brick| location: move_left(brick.location)}
  end
  def right(brick) do
    %{brick| location: move_right(brick.location)}
  end
  def down(brick) do
    %{brick| location: move_down(brick.location)}
  end
  def up(brick) do
    %{brick| location: move_up(brick.location)}
  end
  def rotate(brick) do
    %{brick| rotation: turn(brick.rotation)}
  end
  def turn(270) do
    0
  end
  def turn(degrees) do
    degrees + 90
  end
  def move_down({x,y}) do
    {x, y+1}
  end
  def move_up({x,y}) do
    {x, y-1}
  end
  def move_left({x,y}) do
    {x-1, y}
  end
  def move_right({x,y}) do
    {x+1, y}
  end
end

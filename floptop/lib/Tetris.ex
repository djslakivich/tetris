defmodule Tetris do
  alias Tetris.{Bottom, Brick, Points}

  def try_attempts(oldbrick, change, _) do
    updated_brick = change.(oldbrick)
    points = Brick.prepare_points(updated_brick)
    test_points(points, oldbrick, updated_brick)
  end

  def in_bounds({x, y}) do
    x > 1 and x < 10
  end

  def test_points(points, oldbrick, updated_brick) do
    good =
      for point <- points do
        in_bounds(point)
      end
      |> Enum.all?

    if good, do: updated_brick, else: oldbrick
    end
end

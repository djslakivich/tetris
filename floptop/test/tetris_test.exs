defmodule TetrisTest do
  use ExUnit.Case
  import Tetris
  alias Tetris.{Brick}

  setup do
    test_Brick = %Brick{
      name: :I,
      rotation: 0,
      reflection: true,
      location: {1,0}
    }
    %{
      test_Brick: test_Brick
    }
  end
  describe "rotate" do
    test "rotates 90 degrees", %{test_Brick: test_Brick} do
      actual_Brick = Brick.rotate(test_Brick)
        actual = actual_Brick.rotation
          expected = 90
            assert actual == expected
    end
  end
  describe "down" do
    test "checks if the location is moved down", %{test_Brick: test_Brick} do
      actual_Brick = Brick.down(test_Brick)
        actual = actual_Brick.location
          expected = {1,1}
            assert actual == expected
    end
  end
  describe "left" do
    test "checks if the locations is moved left", %{test_Brick: test_Brick} do
      actual_Brick = Brick.left(test_Brick)
        actual = actual_Brick.location
          expected = {0,0}
            assert actual == expected
    end
  end
  describe "right" do
    test "checks if the locations is moved right", %{test_Brick: test_Brick} do
      actual_Brick = Brick.right(test_Brick)
        actual = actual_Brick.location
          expected = {2,0}
            assert actual == expected
    end
  end
  describe "moving right, success" do
    test "checks to see if the brick moved right with no collision/merges" do
      brick = Brick.random_brick(location: {5,1})
      bottom = %{}
        actual = Tetris.try_right(brick, bottom)
          expected = brick |> Brick.move_right
            assert actual == expected
    end
  end
  describe "reflect" do
    test "checks to see if the reflection is boolean", %{test_Brick: test_Brick} do
      actual_Brick = Brick.reflect(test_Brick)
        actual = actual_Brick.reflection
          expected = false
            assert actual == expected
    end
  end
end

defmodule MyAppWeb.SpaceLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]
  alias Tetris.{Brick, Points}

  @debug true
  @box_width 20
  @box_height 20

  def mount(_session, socket) do
      {:ok, new_game(socket) }
  end
  def begin_svg() do
      """
      <div style="background-color:white;">
        <svg
        version="1.0"
        id="Layer_1"
        xmlns="http://www.w3.org/2000/svg"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        width="300" height="400"
        viewBox="0 0 300 400"
        xml:space="preserve">
      """
  end
  def end_svg() do
      "</svg>
      </div>"
  end
  def boxes(points_with_colors) do
    points_with_colors
    |> Enum.map( fn {x, y, color} ->
      box({x, y}, color)
    end)
    |> Enum.join("\n")
  end
  def box(point, color) do
    """
    #{square(point, shades(color).light)}
    #{triangle(point, shades(color).dark)}
    """
  end
  def square(point, shade) do
    {x, y} = to_pixels(point)
      """
      <rect
        x="#{x+1}" y="#{y+1}"
        style="fill:##{shade}"
        width="#{@box_width - 2}" height="#{@box_height - 2}" />
      """
  end
  def triangle(point, shade) do
    {x, y} = to_pixels(point)
    {w, h} = {@box_width, @box_height}
      """
      <polyline
        style="fill:##{shade}";
        points="#{x + 1}, #{y + 1} #{x + w}, #{y + 1} #{x + w}, #{y + h}" />
      """
  end
  defp to_pixels({x,y}) do
    {(x-1) * @box_width, (y-1) * @box_height}
  end

  def render(assigns) do
    ~L"""
      <div phx-keydown="keydown" phx-target="window">
        <body style="background-color:black;">
          <%= raw begin_svg() %>
            <%= raw boxes(@tetromino) %>
          <%= raw end_svg() %>
        </body>
        <h2 style="color: white;">
        Score: <%= @score %>
        State: <%= @state %>
        </h2>
      <h2 style="color:white;"><%= inspect(@brick) %></h2>
        <button phx-click="click">Start</button>
       </div>
       <%= debug(assigns) %>
      """
  end


  def new_block(socket) do
    brick =
      Brick.random_brick
      |> Map.put(:location, {3, 1})

    assign(socket,
      brick: brick
    )
  end

  def show(socket) do
    brick = socket.assigns.brick

    points =
      brick
      |> Brick.prepare_points
      |> Points.with_color(color(brick))

    assign(socket, tetromino: points)
  end

  defp new_game(socket) do
    assign(socket,
        state: :playing,
        score: 0,
        bottom: %{}
    )
    |> new_block
    |> show
  end

  defp shades(:red) do
    %{light: "DB7160", dark: "AB574B"}
  end
  defp shades(:blue) do
    %{light: "83C1C8", dark: "66969C"}
  end
  defp shades(:green) do
    %{light: "8BBF57", dark: "769359"}
  end
  defp shades(:orange) do
    %{light: "CB8E4E", dark: "AC7842"}
  end
  defp shades(:grey) do
    %{light: "A1A09E", dark: "7F7F7E"}
  end

  defp color(%{name: :t}), do: :red
  defp color(%{name: :i}), do: :blue
  defp color(%{name: :l}), do: :green
  defp color(%{name: :o}), do: :orange
  defp color(%{name: :z}), do: :grey

  def move(direction, socket) do
    socket
    |> do_move(direction)
    |> show
  end
  def rotate(degrees, socket) do
    socket
    |> do_rotate(degrees)
    |> show
  end
  def drop(socket) do
    {bottom, brick, score} = Tetris.Brick.down(brick)
    socket
    |> assign(brick: socket.assigns.brick |> Tetris.try_attempts(&Brick.down/1, []))
    |> show
  end
  def do_rotate(socket, :rotate) do
    assign(socket, brick: socket.assigns.brick |> Tetris.try_attempts(&Brick.rotate/1, []))
  end
  def do_move(socket, :left) do
    assign(socket, brick: socket.assigns.brick |> Tetris.try_attempts(&Brick.left/1, []))
  end
  def do_move(socket, :right) do
    assign(socket, brick: socket.assigns.brick |> Tetris.try_attempts(&Brick.right/1, []))
  end
  def do_move(socket, :up) do
    assign(socket, brick: socket.assigns.brick |> Tetris.try_attempts(&Brick.up/1, []))
  end

  def handle_event("keydown", %{"key" => "ArrowDown"}, socket) do
    {:noreply, drop(socket)}
  end
  def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
    {:noreply, move(:right, socket)}
  end
  def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, move(:left, socket)}
  end
  def handle_event("keydown", %{"key" => "ArrowUp"}, socket) do
    {:noreply, move(:up, socket)}
  end
  def handle_event("keydown", %{"key" => " "}, socket) do
    {:noreply, rotate(:rotate, socket)}
  end
  def handle_event("keydown", _, socket) do
    {:noreply, socket}
  end

  def debug(assigns), do: debug(assigns, @debug, Mix.env)
  def debug(assigns, true, :dev) do
    ~L"""
    <pre>
    <%= raw( @tetromino |> inspect) %>
    </pre>
    """
  end
  def debug(assigns, _, _), do: ""

  def x({x,y}) do
        {((x-1) * @box_width),y}
  end
  def y({x,y}) do
        {x,((y-1) * @box_height)}
  end

end

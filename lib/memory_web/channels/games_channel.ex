defmodule MemoryWeb.GamesChannel do
  use MemoryWeb, :channel

  alias Memory.Game

  def join("games:" <> name, payload, socket) do
    if authorized?(payload) do
      game = Memory.GameBackup.load(name) || Game.new()

      socket =
        socket
        |> assign(:game, game)
        |> assign(:name, name)

      {:ok, %{"join" => name, "game" => game}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("click", %{"clickedIndex" => cardIndex}, socket) do
    game = Game.handleClick(socket.assigns[:game], cardIndex)
    Memory.GameBackup.save(socket.assigns[:name], game)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("reset", %{"reset" => reset}, socket) do
    game = Game.new()
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  def handle_in("unpause", %{"unpause" => unpause}, socket) do
    game = Game.unpause(socket.assigns[:game])
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{"game" => game}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end

defmodule MemoryWeb.PageControllerTest do
  use MemoryWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Memory Game"
  end
end

# defmodule MemoryWeb.PageController do
#   use MemoryWeb, :controller

#   def index(conn, _params) do
#     render(conn, "index.html")
#   end

#   def game(conn, params) do
#     render(conn, "game.html", game: params["game"])
#   end
# end

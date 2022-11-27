defmodule Chat.Plugs.RequireAuth do
  import Phoenix.Controller
  import Plug.Conn

  alias Chat.Repo
  alias Chat.User
  alias Chat.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in first!")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt()
    end
  end

end

defmodule Chat.Plugs.SetUser do
  import Phoenix.Controller
  import Plug.Conn

  alias Chat.Repo
  alias Chat.User
  alias Chat.Router.Helpers


  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :user_id)
    cond do
      user = user_id && Repo.get(User, user_id) ->
        assign(conn, :user, user)
      true ->
        assign(conn, :user, nil)
    end
  end


end

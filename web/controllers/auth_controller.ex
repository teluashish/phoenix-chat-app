defmodule Chat.AuthController do
  use Chat.Web, :controller
  plug Ueberauth
  alias Chat.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    user_changeset = User.changeset(%User{}, %{email: auth.info.email, token: auth.credentials.token, provider: provider})
    signin(conn, user_changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end


  defp signin(conn, user_changeset) do
    case insert(user_changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Signin Successful")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _user_struct} ->
        conn
        |> put_flash(:error, "Error Signing in the User")
        |> redirect(to: topic_path(conn, :index))

    end
  end

  defp insert(user_changeset) do
    case Repo.get_by(User, email: user_changeset.changes.email) do
      nil -> Repo.insert(user_changeset)
      user -> {:ok, user}
    end
  end

end

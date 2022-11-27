defmodule Chat.TopicController do
  use Chat.Web, :controller
  alias Chat.Topic

  plug Chat.Plugs.RequireAuth when action in [:new, :create, :update, :edit, :delete]
  plug :check_topic_owner when action in [:edit, :update, :delete]

  def index(conn, _params ) do
      topics = Repo.all(Topic)
      render conn, "index.html", topics: topics
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  def new(conn, _params) do
    changeset  = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do

    changeset = Topic.changeset(%Topic{},topic)

    changeset = conn.assigns.user
      |> build_assoc(:topics)
      |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, 'Group Created "#{topic.title}" ')
        |> redirect(to: topic_path(conn,:index))
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def edit(conn, %{"id" => topic_id}) do

    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic

  end

  def update(conn, %{"id" => topic_id ,"topic" => topic}) do
    changeset = Repo.get(Topic,topic_id) |> Topic.changeset(topic)
      case Repo.update(changeset) do
        {:ok, topic} ->
          conn
          |> put_flash(:info, 'Group Name Updated to "#{topic.title}" ')
          |> redirect(to: topic_path(conn, :index))
        {:error, changeset} -> render conn, "edit.html", changeset: changeset, topic: topic
      end

  end


  def delete(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic,topic_id)
    topic |> Repo.delete!
    conn
    |> put_flash(:info, '"#{topic.title}" Group Deleted')
    |> redirect(to: topic_path(conn, :index))
  end

  def check_topic_owner(%{params: %{"id" => topic_id}} = conn, _params) do
    if Repo.get(Topic, topic_id).user_id == conn.assigns[:user].id do
      conn
    else
      conn
      |> put_flash(:error, "you don't have permission to do that")
      |> redirect(to: topic_path(conn,:index))
      |> halt()
    end

  end

end

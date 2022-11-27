defmodule Chat.MessagesChannel do
  use Chat.Web, :channel
  alias Chat.{Topic, Message}

  def join( "messages:" <> topic_id , _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get(topic_id)
      |> Repo.preload(messages: [:user])
    {:ok, %{messages: topic.messages}, assign(socket, :topic, topic)}
  end

  # build_assoc here is creating a new message with topic id assigned to it, helping us create a new identical record.
  def handle_in(name, %{"message" => message}, socket) do
    changeset = socket.assigns.topic
      |> build_assoc(:messages, user_id: socket.assigns.user_id)
      |> Message.changeset(%{message: message})

    case Repo.insert(changeset) do
      {:ok, message} ->
        message = Repo.preload(message, :user)
        broadcast!(socket, "messages:#{socket.assigns.topic.id}:new", %{message: message})
        {:reply, :ok, socket}
      {:error, _reason} -> {:reply, {:error, %{errors: changeset}}, socket}
    end

  end

end

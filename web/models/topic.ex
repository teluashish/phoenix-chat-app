defmodule Chat.Topic do
  use Chat.Web, :model

  schema "topics" do
    field :title, :string
    belongs_to :user, Chat.User
    has_many :messages, Chat.Message
  end


  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params,[:title])
      |> validate_required([:title])
  end

end

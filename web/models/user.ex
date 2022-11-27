defmodule Chat.User do
  use Chat.Web, :model
  @derive {Poison.Encoder, only: [:email]}
  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string

    has_many :topics, Chat.Topic
    has_many :messages, Chat.Message
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :provider, :token])
    |> validate_required([:email, :provider, :token])
  end

end

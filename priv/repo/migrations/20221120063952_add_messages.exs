defmodule Chat.Repo.Migrations.AddMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :string
      add :user_id, references(:users)
      add :topic_id, references(:topics, on_delete: :delete_all)

      timestamps()
    end
  end
end

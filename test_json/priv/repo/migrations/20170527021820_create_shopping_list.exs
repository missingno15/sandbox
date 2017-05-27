defmodule TestJSON.Repo.Migrations.CreateShoppingList do
  use Ecto.Migration

  def change do
    create table(:shopping_list) do
      add :items, {:array, :map}
    end
  end
end

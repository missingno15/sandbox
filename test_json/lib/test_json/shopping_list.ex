defmodule TestJSON.ShoppingList do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shopping_list" do
    field :items, {:array, :map}
  end

  def changeset(shopping_list, params \\ %{}) do
    shopping_list
    |> cast(params, [:items])
    |> validate_required([:items])
    |> unique_constraint(:items, name: "sns_constraint", message: "one or more twitter object does not follow schema")
  end
end
